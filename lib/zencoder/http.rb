module Zencoder::HTTP

  class << self
    attr_accessor :default_options
    attr_writer :http_class
  end

  self.default_options = {:timeout => 10000,
                          :headers => {'Accept' => 'application/json',
                                       'Content-Type' => 'application/json'}}

  def self.http_class
    @http_class ||= Zencoder::HTTP::NetHTTP
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
    process_response http_class.send(method, url, self.default_options.merge(options))
  rescue StandardError => e
    raise Zencoder::HTTPError, "#{e.class} - #{e.message}"
  end

  def self.process_response(http_class_response)
    response = Zencoder::Response.new
    response.code = http_class_response.code

    begin
      response.body = JSON.parse(http_class_response.body.to_s)
    rescue JSON::ParserError
      response.body = http_class_response.body
    end

    response.raw_body = http_class_response.body
    response.raw_response = http_class_response
    response
  end

end
