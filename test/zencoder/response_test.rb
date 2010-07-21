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

    context "#body_without_wrapper" do
      should "return the body when the body is a string" do
        assert_equal "some text", Zencoder::Response.new(:body => "some text").body_without_wrapper
      end

      should "return the body when the body is not wrapped in api_response and is a hash" do
        assert_equal({'some' => 'hash'}, Zencoder::Response.new(:body => {'some' => 'hash'}).body_without_wrapper)
      end

      should "return body['api_response'] when body is a hash and body['api_response'] exists" do
        assert_equal({'some' => 'hash'}, Zencoder::Response.new(:body => {'api_response' => {'some' => 'hash'}}).body_without_wrapper)
      end
    end
  end

end
