require 'test_helper'

class ZencoderTest < Test::Unit::TestCase

  should "encode to xml" do
    assert_match /<api-request>/, Zencoder.encode({:api_request => {:input => 'https://example.com'}}, :xml)
  end

  should "encode to json" do
    assert_match /"api_request"/, Zencoder.encode({:api_request => {:input => 'https://example.com'}}, :json)
  end

  should "default to encoding to json" do
    assert_match /"api_request"/, Zencoder.encode({:api_request => {:input => 'https://example.com'}})
  end

  should "not encode when the content is a String" do
    assert_match /^api_request$/, Zencoder.encode("api_request")
  end

  should "decode from xml" do
    assert Zencoder.decode("<api-request><input>https://example.com</input></api-request>", :xml)['api_request']['input']
  end

  should "decode from json" do
    assert Zencoder.decode(%@{"api_request": {"input": "https://example.com"}}@, :json)['api_request']['input']
  end

  should "default to decoding from json" do
    assert Zencoder.decode(%@{"api_request": {"input": "https://example.com"}}@)['api_request']['input']
  end

  should "not decode when content is not a String" do
    assert_equal 1, Zencoder.decode(1)
  end

end
