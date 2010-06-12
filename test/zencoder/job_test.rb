require 'test_helper'

class Zencoder::JobTest < Test::Unit::TestCase

  should "be initializable with a hash" do
    assert_nothing_raised do
      Zencoder::Job.new({})
    end
  end

  should "be initializable with nothing" do
    assert_nothing_raised do
      Zencoder::Job.new
    end
  end

  should "not initialize when passed something other than a hash" do
    assert_raises Zencoder::ArgumentError do
      Zencoder::Job.new(1)
    end
  end

end
