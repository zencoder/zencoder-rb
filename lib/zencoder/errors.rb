module Zencoder
  class Error < StandardError

    def initialize(error_or_message)
      if error_or_message.is_a?(Exception)
        @error = error_or_message
      else
        @message = error_or_message
      end
    end

    def message
      @message || "#{@error.class} (wrapped in a #{self.class}) - #{@error.message}"
    end

    def backtrace
      if @error
        @error.backtrace
      else
        super
      end
    end

    def inspect
      if @error
        "#{@error.inspect} (wrapped in a #{self.class})"
      else
        super
      end
    end

    def to_s
      if @error
        "#{@error.class} (wrapped in a #{self.class}) - #{@error}"
      else
        super
      end
    end
  end

  class HTTPError < Error; end

end
