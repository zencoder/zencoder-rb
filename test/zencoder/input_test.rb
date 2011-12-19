require 'test_helper'

class Zencoder::InputTest < Test::Unit::TestCase

  context Zencoder::Input do
    setup do
      @api_key = 'abc123'
    end

    context ".details" do
      setup do
        @input_id = 1
        @url = "#{Zencoder.base_url}/inputs/#{@input_id}"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Input.details(@input_id, :api_key => @api_key).class
      end
    end

    context ".progress" do
      setup do
        @input_id = 1
        @url = "#{Zencoder.base_url}/inputs/#{@input_id}/progress"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Input.progress(@input_id, :api_key => @api_key).class
      end
    end
  end
end
