module Zencoder
  class HTTP

    include Zencoder::Serializer

    attr_accessor :url, :options, :method

    class << self
      attr_accessor :default_options, :http_backend
    end

    self.http_backend = NetHTTP

    self.default_options = {:timeout => 10000,
                            :headers => {'Accept' => 'application/json',
                                         'Content-Type' => 'application/json'}}

    def initialize(method, url, options={})
      self.method  = method
      self.url     = url
      self.options = options
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
      raise HTTPError.new(e)
    end

    def options=(value)
      value ||= {}

      # Hacky, deeper hash merge
      default_options.keys.each do |key|
        if value.has_key?(key)
          if value[key].is_a?(Hash) && default_options[key].is_a?(Hash)
            value[key] = default_options[key].merge(value[key])
          end
        else
          value[key] = default_options[key]
        end
      end

      @options = value
    end

    def options
      @options || self.options = default_options
    end

    def http_backend
      self.class.http_backend
    end

    def default_options
      self.class.default_options
    end


  protected

    def process(http_response)
      response = Response.new
      response.code = http_response.code

      begin
        response.body = decode(http_response.body.to_s)
      rescue StandardError # Hack! Returns different exceptions depending on the decoding engine
        response.body = http_response.body
      end

      response.raw_body = http_response.body
      response.raw_response = http_response
      response
    end

  end
end
