require "spec_helper"

RSpec.describe Zencoder::HTTP do
  it "haves a default_options hash" do
    assert Zencoder::HTTP.default_options.is_a?(Hash)
  end

  it "haves a default HTTP backend" do
    assert Zencoder::HTTP.http_backend
  end

  it "allows the changing of the HTTP backend" do
    assert_not_equal Zencoder::HTTP.http_backend, Zencoder::HTTP::Typhoeus

    assert_nothing_raised do
      Zencoder::HTTP.http_backend = Zencoder::HTTP::Typhoeus
    end

    assert_equal Zencoder::HTTP.http_backend, Zencoder::HTTP::Typhoeus
  end

  it "raises a Zencoder::HTTPError when there is an HTTP error" do
    expect(Zencoder::HTTP.http_backend).to receive(:get).
      with('https://example.com', Zencoder::HTTP.default_options).
      at_least(:once).
      and_raise(Errno::ECONNREFUSED)

    assert_raises Zencoder::HTTPError do
      Zencoder::HTTP.get('https://example.com')
    end

    begin
      Zencoder::HTTP.get('https://example.com')
    rescue Zencoder::HTTPError => e
      assert_no_match(/perform_method/, e.backtrace.first)
    end
  end

  it "returns a Zencoder::Response" do
    allow(Zencoder::HTTP.http_backend).to receive(:post).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    allow(Zencoder::HTTP.http_backend).to receive(:put).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    allow(Zencoder::HTTP.http_backend).to receive(:get).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    allow(Zencoder::HTTP.http_backend).to receive(:delete).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)

    assert Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').is_a?(Zencoder::Response)
    assert Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').is_a?(Zencoder::Response)
    assert Zencoder::HTTP.get('https://example.com').is_a?(Zencoder::Response)
    assert Zencoder::HTTP.delete('https://example.com').is_a?(Zencoder::Response)
  end

  it "stores the raw response" do
    post_stub = double(:code => 200, :body => '{"some": "hash"}').as_null_object
    allow(Zencoder::HTTP.http_backend).to receive(:post).and_return(post_stub)
    assert_equal post_stub, Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_response
  end

  it "stores the raw response body" do
    allow(Zencoder::HTTP.http_backend).to receive(:post).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    assert_equal '{"some": "hash"}', Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_body
  end

  it "stores the response code" do
    allow(Zencoder::HTTP.http_backend).to receive(:post).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    assert_equal 200, Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').code
  end

  it "JSONs parse the response body" do
    allow(Zencoder::HTTP.http_backend).to receive(:put).and_return(double(:code => 200, :body => '{"some": "hash"}').as_null_object)
    assert_equal({'some' => 'hash'}, Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').body)
  end

  it "stores the raw body if the body fails to be JSON parsed" do
    allow(Zencoder::HTTP.http_backend).to receive(:put).and_return(double(:code => 200, :body => '{"some": bad json').as_null_object)
    assert_equal '{"some": bad json', Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').body
  end

  describe ".post" do
    it "calls post on the http_backend" do
      expect(Zencoder::HTTP.http_backend).to receive(:post).
        with('https://example.com', Zencoder::HTTP.default_options.merge(:body => '{}')).
        and_return(Zencoder::Response.new)

      Zencoder::HTTP.post('https://example.com', '{}')
    end
  end

  describe ".put" do
    it "calls put on the http_backend" do
      expect(Zencoder::HTTP.http_backend).to receive(:put).
        with('https://example.com', Zencoder::HTTP.default_options.merge(:body => '{}')).
        and_return(Zencoder::Response.new)

      Zencoder::HTTP.put('https://example.com', '{}')
    end
  end

  describe ".get" do
    it "calls post on the http_backend" do
      expect(Zencoder::HTTP.http_backend).to receive(:get).
        with('https://example.com', Zencoder::HTTP.default_options).
        and_return(Zencoder::Response.new)

      Zencoder::HTTP.get('https://example.com')
    end
  end

  describe ".delete" do
    it "calls post on the http_backend" do
      expect(Zencoder::HTTP.http_backend).to receive(:delete).
        with('https://example.com', Zencoder::HTTP.default_options).
        and_return(Zencoder::Response.new)

      Zencoder::HTTP.delete('https://example.com')
    end
  end
end

