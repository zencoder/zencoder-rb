module Zencoder::HTTPS

  class << self
    attr_accessor :default_options
  end

  self.default_options = {:timeout => 10000,
                          :headers => {'Accept' => 'application/json',
                                       'Content-Type' => 'application/json'}}

  def self.post(url, body, options={})
    options = self.default_options.merge(options).merge(:body => body)
    process_response Typhoeus::Request.post(url, options)
  rescue StandardError => e
    raise Zencoder::HTTPSError, "#{e.class} - #{e.message}"
  end

protected

  def self.process_response(typhoeus_response)
    response = Zencoder::Response.new
    response.code = typhoeus_response.code

    begin
      response.body = JSON.parse(typhoeus_response.body)
    rescue JSON::ParserError
      response.body = typhoeus_response.body
    end

    response.raw_body = typhoeus_response.body
    response.raw_response = typhoeus_response
    response
  end

end
