require "spec_helper"

RSpec.describe Zencoder::Output do
  before do
    @api_key = 'abc123'
  end

  describe ".details" do
    before do
      @output_id = 1
      @url = "#{Zencoder.base_url}/outputs/#{@output_id}"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Output.details(@output_id, :api_key => @api_key).class
    end
  end

  describe ".progress" do
    before do
      @output_id = 1
      @url = "#{Zencoder.base_url}/outputs/#{@output_id}/progress"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Output.progress(@output_id, :api_key => @api_key).class
    end
  end
end
