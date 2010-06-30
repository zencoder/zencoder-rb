module Zencoder
  class HTTP

    class << self
      attr_accessor :default_options
      attr_writer :http_backend
    end

    attr_accessor :body, :url, :options, :method, :format

    self.default_options = {:timeout => 10000,
                            :headers => {'Accept' => 'application/json',
                                         'Content-Type' => 'application/json'}}

    def self.http_backend
      @http_backend ||= Zencoder::HTTP::NetHTTP
    end

    def initialize(method, url, options={})
      self.method  = method
      self.url     = url
      self.options = options
      self.format  = options.delete(:format)
      self.body    = options.delete(:body)
    end

    def self.post(url, body, options={})
      new(:post, url, options.merge(:body => body)).perform_method
    end

    def self.put(url, body, options={})
      new(:put, url, options.merge(:body => body)).perform_method
    end

    def self.get(url, options={})
      new(:get, url, options).perform_method
    end

    def self.delete(url, options={})
      new(:delete, url, options).perform_method
    end

    def perform_method
      process(http_backend.send(method, url, options))
    rescue StandardError => e
      raise Zencoder::HTTPError, "#{e.class} - #{e.message}"
    end

    def options=(value)
      @options = default_options.merge(value || {})

      options[:headers] ||= {}
      options[:headers]['Accept'] ||= "application/#{format}"
      options[:headers]['Content-Type'] ||= "application/#{format}"

      options
    end

    def options
      @options || self.options = default_options
    end

    def format
      @format ||= :json
    end

    def http_backend
      self.class.http_backend
    end

    def default_options
      self.class.default_options
    end


  protected

    def process(http_response)
      response = Zencoder::Response.new
      response.code = http_response.code

      begin
        response.body = Zencoder.decode(http_response.body.to_s, format)
      rescue StandardError # Hack! Returns different exceptions depending on the decoding engine
        response.body = http_response.body
      end

      response.raw_body = http_response.body
      response.raw_response = http_response
      response
    end

  end
end
