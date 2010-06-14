# Ruby's Net/HTTP Sucks
# Borrowed root cert checking from http://redcorundum.blogspot.com/2008/03/ssl-certificates-and-nethttps.html

module Zencoder::HTTP::NetHTTP

  class << self
    attr_accessor :root_cert_paths
  end

  self.root_cert_paths = ['/etc/ssl/certs',
                          '/var/ssl',
                          '/usr/share/ssl',
                          '/usr/ssl',
                          '/etc/ssl',
                          '/usr/local/openssl',
                          '/usr/lib/ssl',
                          '/System/Library/OpenSSL',
                          '/etc/openssl',
                          '/usr/local/ssl',
                          '/etc/pki/tls']

  def self.post(url, options={})
    uri = URI.parse(url)
    add_params_to_query_string(uri, options[:params])

    request = Net::HTTP::Post.new(path_with_query_string(uri))

    add_headers(request, options[:headers])
    add_body(request, options[:body])

    request_with_timeout(http_with_ssl(uri), request, options[:timeout])
  end

  def self.put(url, options={})
    uri = URI.parse(url)
    add_params_to_query_string(uri, options[:params])

    request = Net::HTTP::Put.new(path_with_query_string(uri))

    add_headers(request, options[:headers])
    add_body(request, options[:body])

    request_with_timeout(http_with_ssl(uri), request, options[:timeout])
  end

  def self.get(url, options={})
    uri = URI.parse(url)
    add_params_to_query_string(uri, options[:params])

    request = Net::HTTP::Get.new(path_with_query_string(uri))

    add_headers(request, options[:headers])

    request_with_timeout(http_with_ssl(uri), request, options[:timeout])
  end

  def self.delete(url, options={})
    uri = URI.parse(url)
    add_params_to_query_string(uri, options[:params])

    request = Net::HTTP::Delete.new(path_with_query_string(uri))

    add_headers(request, options[:headers])

    request_with_timeout(http_with_ssl(uri), request, options[:timeout])
  end


protected

  def self.http_with_ssl(uri)
    http = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == 'https'
      http.use_ssl = true

      if root_cert_path = locate_root_cert_path
        http.ca_path = root_cert_path
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.verify_depth = 5
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    http
  end

  def self.path_with_query_string(uri)
    if uri.path.empty?
      uri.path = '/'
    end

    if uri.query.to_s.empty?
      uri.path
    else
      uri.path + '?' + uri.query.to_s
    end
  end

  def self.locate_root_cert_path
    root_cert_paths.detect do |root_cert_path|
      File.directory?(root_cert_path)
    end
  end

  def self.add_headers(request, headers)
    if headers
      headers.each do |header, value|
        request.add_field(header.to_s, value.to_s)
      end
    end
  end

  def self.add_body(request, body)
    if body
      request.body = body
    end
  end

  def self.add_params_to_query_string(uri, params)
    if params
      params_as_query = params.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join('&')
      if uri.query.to_s.empty?
        uri.query = params_as_query
      else
        uri.query = [uri.query.to_s, params_as_query].join('&')
      end
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
