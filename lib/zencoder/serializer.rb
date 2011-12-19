module Zencoder
  module Serializer

    extend self

    def self.included(klass)
      klass.extend(self)
    end

    def encode(content)
      if content.is_a?(String) || content.nil?
        content
      else
        MultiJson.encode(content)
      end
    end

    def decode(content)
      if content.is_a?(String)
        MultiJson.decode(content)
      else
        content
      end
    end

  end
end
