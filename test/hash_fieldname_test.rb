require "test_helper"

class HashFieldnameTest < BaseTest
  def test_hash_fieldname
    n = 200

    n.times do
      HashFieldnameModel.create
    end

    assert_equal HashFieldnameModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
    assert_equal Mongoid::Sequence::Sequences.where(fieldname: "shipment_auto_increment").first.seq, n
  end
end
