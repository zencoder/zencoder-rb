require 'test_helper'

class Zencoder::OutputTest < Test::Unit::TestCase

  context Zencoder::Output do
    setup do
      @api_key = 'abc123'
    end

    context ".progress" do
      setup do
        @output_id = 1
        @url = "#{Zencoder.base_url}/outputs/#{@output_id}/progress"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Output.progress(@output_id, :api_key => @api_key).class
      end
    end
  end
end