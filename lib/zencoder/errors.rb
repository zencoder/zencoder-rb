class Zencoder
  class Error < StandardError
    def initialize(error_or_message)
      if error_or_message.is_a?(Exception)
        @error = error_or_message
      else
        @message = error_or_message
      end
    end

    def message
      @message || "#{@error.class} - #{@error.message}"
    end

    def backtrace
      @error && @error.backtrace || super
    end
  end

  class HTTPError < Error; end
end
