class HashFieldnameModel
  include Mongoid::Document
  include Mongoid::Sequence

  field :auto_increment, :type => Integer

  sequence shipment: :auto_increment
end
