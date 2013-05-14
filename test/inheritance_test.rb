require "test_helper"

class InheritanceTest < BaseTest
  def test_inheritance
    n = 200

    n.times do
      SubFirstSequencedModel.create
    end

    assert_equal SubFirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end
end
