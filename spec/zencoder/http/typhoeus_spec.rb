require "spec_helper"

# Most useless tests ever, but who knows, right?

if !defined?(Typhoeus)
  module ::Typhoeus
    module Request
      extend self

      def get(*)
      end

      def put(*)
      end

      def post(*)
      end

      def delete(*)
      end
    end
  end
end

RSpec.describe Zencoder::HTTP::Typhoeus do
  describe ".post" do
    it "POSTs using Typhoeus" do
      expect(Typhoeus::Request).to receive(:post).with('https://example.com', {:some => 'options'})
      Zencoder::HTTP::Typhoeus.post('https://example.com', {:some => 'options'})
    end
  end

  describe ".put" do
    it "PUTs using Typhoeus" do
      expect(Typhoeus::Request).to receive(:put).with('https://example.com', {:some => 'options'})
      Zencoder::HTTP::Typhoeus.put('https://example.com', {:some => 'options'})
    end
  end

  describe ".get" do
    it "GETs using Typhoeus" do
      expect(Typhoeus::Request).to receive(:get).with('https://example.com', {:some => 'options'})
      Zencoder::HTTP::Typhoeus.get('https://example.com', {:some => 'options'})
    end
  end

  describe ".delete" do
    it "DELETEs using Typhoeus" do
      expect(Typhoeus::Request).to receive(:delete).with('https://example.com', {:some => 'options'})
      Zencoder::HTTP::Typhoeus.delete('https://example.com', {:some => 'options'})
    end
  end

  it "skips ssl verification" do
    expect(Typhoeus::Request).to receive(:get).with('https://example.com', {:disable_ssl_peer_verification => true})
    Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true})
  end

  it "uses the path to the cert file" do
    expect(Typhoeus::Request).to receive(:get).with('https://example.com', {:disable_ssl_peer_verification => true, :sslcert => "/foo/bar/baz.crt"})
    Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true, :ca_file => "/foo/bar/baz.crt"})
  end

  it "uses the path to the certs directory" do
    expect(Typhoeus::Request).to receive(:get).with('https://example.com', {:disable_ssl_peer_verification => true, :capath => "/foo/bar/baz.crt"})
    Zencoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true, :ca_path => "/foo/bar/baz.crt"})
  end
end
