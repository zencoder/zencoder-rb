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
        if MultiJson.respond_to?(:dump)
          MultiJson.dump(content)
        else
          MultiJson.encode(content)
        end
      end
    end

    def decode(content)
      if content.is_a?(String)
        if MultiJson.respond_to?(:dump)
          MultiJson.load(content)
        else
          MultiJson.decode(content)
        end
      else
        content
      end
    end

  end
end
