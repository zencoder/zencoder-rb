require 'test_helper'

class Zencoder::HTTP::TyphoeusTest < Test::Unit::TestCase

  # Most useless tests ever, but who knows, right?

  if !defined?(Typhoeus)
    module ::Typhoeus
      module Request
      end
    end
  end

  context Zencoder::HTTP::Typhoeus do
    context ".post" do
      should "POST using Typhoeus" do
        Typhoeus::Request.expects(:post).with('https://example.com', {:some => 'options'})
        Zencoder::HTTP::Typhoeus.post('https://example.com', {:some => 'options'})
      end
    end

    context ".put" do
      should "PUT using Typhoeus" do
        Typhoeus::Request.expects(:put).with('https://example.com', {:some => 'options'})
        Zencoder::HTTP::Typhoeus.put('https://example.com', {:some => 'options'})
      end
    end

    context ".get" do
      should "GET using Typhoeus" do
        Typhoeus::Request.expects(:get).with('https://example.com', {:some => 'options'})
        Zencoder::HTTP::Typhoeus.get('https://example.com', {:some => 'options'})
      end
    end

    context ".delete" do
      should "DELETE using Typhoeus" do
        Typhoeus::Request.expects(:delete).with('https://example.com', {:some => 'options'})
        Zencoder::HTTP::Typhoeus.delete('https://example.com', {:some => 'options'})
      end
    end

    should "skip ssl verification" do
      Typhoeus::Request.expects(:get).with('https://example.com', {:disable_ssl_peer_verification => true})
      Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true})
    end

    should "use the path to the cert file" do
      Typhoeus::Request.expects(:get).with('https://example.com', {:disable_ssl_peer_verification => true, :sslcert => "/foo/bar/baz.crt"})
      Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true, :ca_file => "/foo/bar/baz.crt"})
    end

    should "use the path to the certs directory" do
      Typhoeus::Request.expects(:get).with('https://example.com', {:disable_ssl_peer_verification => true, :capath => "/foo/bar/baz.crt"})
      Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true, :ca_path => "/foo/bar/baz.crt"})
    end
  end

end
