module Zencoder
  class Response < Base

    attr_accessor :code, :body, :raw_body, :raw_response

    def initialize(options={})
      options.each do |k, v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end
    end

    def success?
      code.to_i > 199 && code.to_i < 300
    end

    def errors
      if body.is_a?(Hash)
        Array(body['errors']).compact
      else
        []
      end
    end

    def body_without_wrapper
      if body.is_a?(Hash) && body['api_response']
        body['api_response']
      else
        body
      end
    end

  end
end
