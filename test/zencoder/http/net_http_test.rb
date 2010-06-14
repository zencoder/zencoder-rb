require 'test_helper'

class Zencoder::HTTP::TyphoeusTest < Test::Unit::TestCase

  context Zencoder::HTTP::NetHTTP do

    context "call options" do
      should "request with timeout" do
        stub_request(:post, "https://example.com")
        Timeout.expects(:timeout).with(0.001)
        Zencoder::HTTP::NetHTTP.post('https://example.com', :timeout => 1)
      end

      should "request without timeout" do
        stub_request(:post, "https://example.com")
        Timeout.stubs(:timeout).raises(Exception)
        assert_nothing_raised do
          Zencoder::HTTP::NetHTTP.post('https://example.com', :timeout => nil)
        end
      end

      should "add params to the query string if passed" do
        stub_request(:post, "https://example.com/path?some=param")
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:params => {:some => 'param'}})
      end

      should "add params to the existing query string if passed" do
        stub_request(:post,'https://example.com/path?original=param&some=param')
        Zencoder::HTTP::NetHTTP.post('https://example.com/path?original=param', {:params => {:some => 'param'}})
      end

      should "add headers" do
        stub_request(:post,'https://example.com/path').with(:headers => {'some' => 'header'})
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:headers => {:some => 'header'}})
      end

      should "add the body to the request" do
        stub_request(:post, 'https://example.com/path').with(:body => '{"some": "body"}')
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', {:body => '{"some": "body"}'})
      end
    end

    context "SSL verification" do
      should "not verify when the SSL directory is not found" do
        http_stub = stub(:use_ssl= => true, :ca_path= => true, :verify_depth= => true, :request => true)
        http_stub.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)
        Net::HTTP.expects(:new).returns(http_stub)
        Zencoder::HTTP::NetHTTP.expects(:locate_root_cert_path).returns('/fake/path')
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', '{}')
      end

      should "verify when the SSL directory is found" do
        http_stub = stub(:use_ssl= => true, :ca_path= => true, :verify_depth= => true, :request => true)
        http_stub.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
        Net::HTTP.expects(:new).returns(http_stub)
        Zencoder::HTTP::NetHTTP.expects(:locate_root_cert_path).returns(nil)
        Zencoder::HTTP::NetHTTP.post('https://example.com/path', '{}')
      end
    end

    context ".post" do
      should "POST to specified body to the specified path" do
        stub_request(:post, 'https://example.com').with(:body => '{}')
        Zencoder::HTTP::NetHTTP.post('https://example.com', :body => '{}')
      end
    end

    context ".put" do
      should "PUT to specified body to the specified path" do
        stub_request(:put, 'https://example.com').with(:body => '{}')
        Zencoder::HTTP::NetHTTP.put('https://example.com', :body => '{}')
      end
    end

    context ".get" do
      should "GET to specified body to the specified path" do
        stub_request(:get, 'https://example.com')
        Zencoder::HTTP::NetHTTP.get('https://example.com')
      end
    end

    context ".delete" do
      should "DELETE to specified body to the specified path" do
        stub_request(:delete, 'https://example.com')
        Zencoder::HTTP::NetHTTP.delete('https://example.com')
      end
    end
  end

end
