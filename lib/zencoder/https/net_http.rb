# Ruby's Net/HTTP Sucks
# Borrowed root cert checking from http://redcorundum.blogspot.com/2008/03/ssl-certificates-and-nethttps.html

module Zencoder::HTTPS::NetHTTP

  class << self
    attr_accessor :root_cert_path
  end

  self.root_cert_path = '/etc/ssl/certs'

  def self.post(url, options)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)

    setup_ssl(http)

    add_headers(request, options[:headers])
    add_body(request, options[:body])

    request_with_timeout(http, request, options[:timeout])
  end


protected

  def self.setup_ssl(http)
    http.use_ssl = true

    if File.directory?(self.root_cert_path)
      http.ca_path = self.root_cert_path
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5
    else
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def self.add_headers(request, headers)
    if headers
      headers.each do |header, value|
        request.add_field(header, value)
      end
    end
  end

  def self.add_body(request, body)
    if body
      request.body = body
    end
  end

  def self.request_with_timeout(http, request, timeout)
    if timeout
      Timeout.timeout(timeout / 1000.0) do
        http.request(request)
      end
    else
      http.request(request)
    end
  end

end
