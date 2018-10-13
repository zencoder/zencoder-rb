require "spec_helper"

RSpec.describe Zencoder::Input do
  before do
    @api_key = 'abc123'
  end

  describe ".details" do
    before do
      @input_id = 1
      @url = "#{Zencoder.base_url}/inputs/#{@input_id}"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Input.details(@input_id, :api_key => @api_key).class
    end
  end

  describe ".progress" do
    before do
      @input_id = 1
      @url = "#{Zencoder.base_url}/inputs/#{@input_id}/progress"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Input.progress(@input_id, :api_key => @api_key).class
    end
  end
end
