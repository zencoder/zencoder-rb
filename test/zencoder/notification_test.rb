require 'test_helper'

class Zencoder::JobTest < Test::Unit::TestCase

  context Zencoder::Notification do
    context ".list" do
      setup do
        @url = "#{Zencoder.base_url}/notifications"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key,
                                                            :page => 1,
                                                            :per_page => 50}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Notification.list(:api_key => @api_key).class
      end
    end
  end

end
