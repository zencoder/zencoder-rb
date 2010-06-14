require 'test_helper'

class Zencoder::ResponseTest < Test::Unit::TestCase

  context Zencoder::Response do
    context "#success?" do
      should "return true when code is between 200 and 299" do
        assert Zencoder::Response.new(:code => 200).success?
        assert Zencoder::Response.new(:code => 299).success?
        assert Zencoder::Response.new(:code => 250).success?
      end

      should "return false when code it less than 200 or greater than 299" do
        assert !Zencoder::Response.new(:code => 300).success?
        assert !Zencoder::Response.new(:code => 199).success?
      end
    end

    context "#errors" do
      should "return an empty array when body is not a Hash" do
        assert_equal [], Zencoder::Response.new(:body => 1).errors
        assert_equal [], Zencoder::Response.new(:body => "something").errors
        assert_equal [], Zencoder::Response.new(:body => [1]).errors
      end

      should "return the value of the key 'errors' as a compacted array when body is a Hash" do
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => ['must be awesome']}).errors
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => 'must be awesome'}).errors
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => ['must be awesome', nil]}).errors
        assert_same_elements [], Zencoder::Response.new(:body => {}).errors
      end
    end
  end

end
