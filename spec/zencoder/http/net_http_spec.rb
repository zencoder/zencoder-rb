require "spec_helper"

RSpec.describe Zencoder::HTTP::NetHTTP do

  describe "call options" do
    it "requests with timeout" do
      stub_request(:post, "https://example.com")
      expect(Timeout).to receive(:timeout).with(0.001)
      Zencoder::HTTP::NetHTTP.post('https://example.com', :timeout => 1)
    end

    it "requests without timeout" do
      stub_request(:post, "https://example.com")
      allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)
      assert_nothing_raised do
        Zencoder::HTTP::NetHTTP.post('https://example.com', :timeout => nil)
      end
    end

    it "adds params to the query string if passed" do
      stub_request(:post, "https://example.com/path?some=param")
      Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:params => {:some => 'param'}})
    end

    it "adds params to the existing query string if passed" do
      stub_request(:post,'https://example.com/path?original=param&some=param')
      Zencoder::HTTP::NetHTTP.post('https://example.com/path?original=param', {:params => {:some => 'param'}})
    end

    it "adds headers" do
      stub_request(:post,'https://example.com/path').with(:headers => {'some' => 'header'})
      Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:headers => {:some => 'header'}})
    end

    it "adds the body to the request" do
      stub_request(:post, 'https://example.com/path').with(:body => '{"some": "body"}')
      Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:body => '{"some": "body"}'})
    end
  end

  describe "SSL verification" do
    before do
      @cert_store = double(:add_file => true, :add_path => true, :flags= => true, :set_default_paths => true).as_null_object
      @http_stub = double(:use_ssl= => true, :request => true, :verify_mode= => true, :cert_store= => true, :cert_store => @cert_store).as_null_object
      expect(::Net::HTTP).to receive(:new).and_return(@http_stub)
    end

    describe "when set to skip ssl verification" do
      it "nots verify" do
        expect(@http_stub).to receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', :skip_ssl_verify => true)
      end

      it "nots setup a custom cert store" do
        expect(@http_stub).to_not receive(:cert_store=)
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', :skip_ssl_verify => true)
      end
    end

    describe "when set to do ssl verification" do
      it "setups a custom cert store" do
        expect(@http_stub).to receive(:cert_store=)
        Zencoder::HTTP::NetHTTP.post('https://example.com/path')
      end

      it "sets the default paths on the custom cert store" do
        expect(@cert_store).to receive(:set_default_paths)
        Zencoder::HTTP::NetHTTP.post('https://example.com/path')
      end

      it "sets the ca_file when it is passed in" do
        expect(@cert_store).to receive(:add_file).with("/foo/bar/baz.crt")
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', :ca_file => "/foo/bar/baz.crt")
      end

      it "sets the ca_path when it is passed in" do
        expect(@cert_store).to receive(:add_path).with("/foo/bar/")
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', :ca_path => "/foo/bar/")
      end
    end

  end

  describe ".post" do
    it "POSTs to specified body to the specified path" do
      stub_request(:post, 'https://example.com').with(:body => '{}')
      Zencoder::HTTP::NetHTTP.post('https://example.com', :body => '{}')
    end

    it "POSTs with an empty body if none is provided" do
      stub_request(:post, 'https://example.com').with(:body => '')
      Zencoder::HTTP::NetHTTP.post('https://example.com')
    end
  end

  describe ".put" do
    it "PUTs to specified body to the specified path" do
      stub_request(:put, 'https://example.com').with(:body => '{}')
      Zencoder::HTTP::NetHTTP.put('https://example.com', :body => '{}')
    end

    it "PUTs with an empty body if none is provided" do
      stub_request(:put, 'https://example.com').with(:body => '')
      Zencoder::HTTP::NetHTTP.put('https://example.com')
    end
  end

  describe ".get" do
    it "GETs to specified body to the specified path" do
      stub_request(:get, 'https://example.com')
      Zencoder::HTTP::NetHTTP.get('https://example.com')
    end
  end

  describe ".delete" do
    it "DELETEs to specified body to the specified path" do
      stub_request(:delete, 'https://example.com')
      Zencoder::HTTP::NetHTTP.delete('https://example.com')
    end
  end
end
