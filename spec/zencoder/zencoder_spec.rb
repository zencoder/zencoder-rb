require "spec_helper"

RSpec.describe Zencoder do

  it "allows user to set an api key" do
    Zencoder.api_key = "123"
    assert_equal Zencoder::Job.api_key, "123"
  end

  it "allows ENV variable to set an api key" do
    ENV['ZENCODER_API_KEY'] = "321"
    assert_equal Zencoder::Job.api_key, "321"
  end

  it "takes user-supplie api key over ENV-supplied key" do
    Zencoder.api_key = "123"
    ENV['ZENCODER_API_KEY'] = "321"
    assert_equal Zencoder::Job.api_key, "123"
  end

  it "encodes to json" do
    assert_match(/"api_request"/, Zencoder::Serializer.encode({:api_request => {:input => 'https://example.com'}}))
  end

  it "nots encode when the content is a String" do
    assert_match(/^api_request$/, Zencoder::Serializer.encode("api_request"))
  end

  it "decodes from json" do
    assert Zencoder::Serializer.decode(%@{"api_request": {"input": "https://example.com"}}@)['api_request']['input']
  end

  it "does not decode when content is not a String" do
    assert_equal 1, Zencoder::Serializer.decode(1)
  end

end
