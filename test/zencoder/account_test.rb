require 'test_helper'

class Zencoder::AccountTest < Test::Unit::TestCase

  context Zencoder::Account do
    setup do
      @api_key = 'abc123'
    end

    context ".create" do
      setup do
        @url = "#{Zencoder.base_url}/account"
        @params = {:api_key => @api_key}
        @params_as_json = Zencoder::Serializer.encode(@params, :json)
      end

      should "POST to the correct url and return a response" do
        Zencoder::HTTP.stubs(:post).with(@url, @params_as_json, {}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Account.create(@params).class
      end
    end

    context ".details" do
      setup do
        @url = "#{Zencoder.base_url}/account"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Account.details(:api_key => @api_key).class
      end
    end

    context ".integration" do
      setup do
        @url = "#{Zencoder.base_url}/account/integration"
      end

      should "PUT the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Account.integration(:api_key => @api_key).class
      end
    end

    context ".live" do
      setup do
        @url = "#{Zencoder.base_url}/account/live"
      end

      should "PUT the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Account.live(:api_key => @api_key).class
      end
    end
  end
end
