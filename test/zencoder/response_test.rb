require 'test_helper'

class Zencoder::ResponseTest < Test::Unit::TestCase

  should "return true when successful" do
    assert Zencoder::Response.new(:code => 200).success?
  end

  should "return false when not successful" do
    assert !Zencoder::Response.new(:code => 404).success?
  end

end
