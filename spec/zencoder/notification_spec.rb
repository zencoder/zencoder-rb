require "spec_helper"

RSpec.describe Zencoder::Notification do
  describe ".list" do
    before do
      @url = "#{Zencoder.base_url}/notifications"
      @api_key = 'asdfasdf'
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :page => 1,
                                                          :per_page => 50},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Notification.list(:api_key => @api_key).class
    end
  end
end
