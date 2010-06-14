module Zencoder::HTTP

  class << self
    attr_accessor :default_options
    attr_writer :http_backend
  end

  self.default_options = {:timeout => 10000,
                          :headers => {'Accept' => 'application/json',
                                       'Content-Type' => 'application/json'}}

  def self.http_backend
    @http_backend ||= Zencoder::HTTP::NetHTTP
  end

  def self.post(url, body, options={})
    perform_method(:post, url, options.merge(:body => body))
  end

  def self.put(url, body, options={})
    perform_method(:put, url, options.merge(:body => body))
  end

  def self.get(url, options={})
    perform_method(:get, url, options)
  end

  def self.delete(url, options={})
    perform_method(:delete, url, options)
  end

protected

  def self.perform_method(method, url, options)
    process_response http_backend.send(method, url, self.default_options.merge(options))
  rescue StandardError => e
    raise Zencoder::HTTPError, "#{e.class} - #{e.message}"
  end

  def self.process_response(http_backend_response)
    response = Zencoder::Response.new
    response.code = http_backend_response.code

    begin
      response.body = MultiJson.decode(http_backend_response.body.to_s)
    rescue StandardError # Hack! Returns different exceptions depending on the JSON engine
      response.body = http_backend_response.body
    end

    response.raw_body = http_backend_response.body
    response.raw_response = http_backend_response
    response
  end

end
