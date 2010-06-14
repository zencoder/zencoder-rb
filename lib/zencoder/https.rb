module Zencoder::HTTPS

  class << self
    attr_accessor :default_options
    attr_writer :http_class
  end

  self.default_options = {:timeout => 10000,
                          :headers => {'Accept' => 'application/json',
                                       'Content-Type' => 'application/json'}}

  def self.http_class
    @http_class ||= Zencoder::HTTPS::NetHTTP
  end

  def self.post(url, body, options={})
    options = self.default_options.merge(options).merge(:body => body)
    process_response http_class.post(url, options)
  rescue StandardError => e
    raise Zencoder::HTTPSError, "#{e.class} - #{e.message}"
  end

protected

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
