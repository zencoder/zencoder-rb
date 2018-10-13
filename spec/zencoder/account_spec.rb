require "spec_helper"

RSpec.describe Zencoder::Account do
  before do
    @api_key = 'abc123'
  end

  describe ".create" do
    before do
      @url = "#{Zencoder.base_url}/account"
      @params = {:api_key => @api_key}
      @params_as_json = Zencoder::Serializer.encode(@params)
    end

    it "POSTs to the correct url and return a response" do
      expect(Zencoder::HTTP).to receive(:post).with(@url, @params_as_json, {}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Account.create(@params).class
    end
  end

  describe ".details" do
    before do
      @url = "#{Zencoder.base_url}/account"
    end

    it "GETs the correct url and return a response" do
      expect(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Account.details(:api_key => @api_key).class
    end
  end

  describe ".integration" do
    before do
      @url = "#{Zencoder.base_url}/account/integration"
    end

    it "PUTs the correct url and return a response" do
      expect(Zencoder::HTTP).to receive(:put).with(@url, nil, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Account.integration(:api_key => @api_key).class
    end
  end

  describe ".live" do
    before do
      @url = "#{Zencoder.base_url}/account/live"
    end

    it "PUTs the correct url and return a response" do
      expect(Zencoder::HTTP).to receive(:put).with(@url, nil, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Account.live(:api_key => @api_key).class
    end
  end
end
