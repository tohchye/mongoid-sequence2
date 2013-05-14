require "mongoid-sequence2/version"
require "active_support/concern"
require "active_support/core_ext/class/attribute"

module Mongoid
  module Sequence
    extend ActiveSupport::Concern

    included do
      set_callback :validate, :before, :set_sequence, :unless => :persisted?
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :sequence_fields
    end

    module ClassMethods

      def sequence(fieldname)
        self.sequence_fields ||= []
        self.sequence_fields << fieldname
      end
    end

    class Sequences
      include Mongoid::Document
      store_in collection: "__sequences"

      field :fieldname
      field :seq, type: Integer

      def self.get_next_sequence(collection, fieldname)
        Sequences.where(fieldname: "#{collection}_#{fieldname}").find_and_modify({'$inc' => {'seq' => 1}}, {'upsert' => 'true', :new => true}).seq
      end
    end

    def set_sequence
      self.class.sequence_fields.each do |f|
        if f.is_a?(Hash)
          f.each do |k,v|
            Array(v).each { |sf| self[sf] = Sequences.get_next_sequence(k, sf) }
          end
        else
          self[f] = Sequences.get_next_sequence(self.class.name.underscore, f)
        end
      end
    end

  end
end
