# Ruby's Net/HTTP Sucks
# Borrowed root cert checking from http://redcorundum.blogspot.com/2008/03/ssl-certificates-and-nethttps.html

module Zencoder
  class HTTP
    class NetHTTP

      attr_accessor :method, :url, :uri, :body, :params, :headers, :timeout, :skip_ssl_verify, :options

      class << self
        attr_accessor :root_cert_paths, :skip_setting_root_cert_path
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

      def initialize(method, url, options)
        @method          = method
        @url             = url
        @body            = options.delete(:body)
        @params          = options.delete(:params)
        @headers         = options.delete(:headers)
        @timeout         = options.delete(:timeout)
        @skip_ssl_verify = options.delete(:skip_ssl_verify)
        @options         = options
      end

      def self.post(url, options={})
        new(:post, url, options).perform
      end

      def self.put(url, options={})
        new(:put, url, options).perform
      end

      def self.get(url, options={})
        new(:get, url, options).perform
      end

      def self.delete(url, options={})
        new(:delete, url, options).perform
      end

      def perform
        deliver(http, request)
      end


    protected

      def deliver(http, request)
        if timeout
          Timeout.timeout(timeout / 1000.0) do
            http.request(request)
          end
        else
          http.request(request)
        end
      end

      def http
        u = uri

        http = Net::HTTP.new(u.host, u.port)

        if u.scheme == 'https'
          http.use_ssl = true
          root_cert_path = locate_root_cert_path

          if !skip_ssl_verify && (self.class.skip_setting_root_cert_path || root_cert_path)
            http.ca_path = root_cert_path unless self.class.skip_setting_root_cert_path
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.verify_depth = 5
          else
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
        end

        http
      end

      def request
        r = request_class.new(path)
        r.body = body if body
        if headers
          headers.each do |header, value|
            r.add_field(header.to_s, value.to_s)
          end
        end
        r
      end

      def uri
        u = URI.parse(url)

        if params
          params_as_query = params.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join('&')
          if u.query.to_s.empty?
            u.query = params_as_query
          else
            u.query = [u.query.to_s, params_as_query].join('&')
          end
        end

        u
      end

      def path
        u = uri

        if u.path.empty?
          u.path = '/'
        end

        if u.query.to_s.empty?
          u.path
        else
          u.path + '?' + u.query.to_s
        end
      end

      def request_class
        Net::HTTP.const_get(method.to_s.capitalize)
      end

      def locate_root_cert_path
        self.class.root_cert_paths.detect do |root_cert_path|
          File.directory?(root_cert_path)
        end
      end

    end
  end
end
