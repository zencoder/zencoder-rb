module Zencoder
  module Serializer

    extend self

    def self.included(klass)
      klass.extend(self)
    end

    def encode(content, format=nil)
      if content.is_a?(String)
        content
      elsif format.to_s == 'xml'
        if content.is_a?(Hash) && content.keys.size == 1
          content[content.keys.first].to_xml(:root => content.keys.first)
        else
          content.to_xml
        end
      else
        content.to_json
      end
    end

    def decode(content, format=nil)
      if content.is_a?(String)
        if format.to_s == 'xml'
          Hash.from_xml(content)
        else
          ActiveSupport::JSON.decode(content)
        end
      else
        content
      end
    end

  end
end
