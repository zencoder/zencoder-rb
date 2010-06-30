module Zencoder

  extend self

  class << self
    attr_accessor :base_url
    attr_accessor :api_key
  end

  self.base_url = 'https://app.zencoder.com/api'

  def encode(content, format)
    if content.is_a?(String)
      content
    elsif format.to_s == 'xml'
      content.to_xml
    elsif
      content.to_json
    end
  end

  def decode(content, format)
    if content.is_a?(String)
      if format.to_s == 'xml'
        ActiveSupport::XmlMini.parse(content)
      else
        ActiveSupport::JSON.decode(content)
      end
    else
      content
    end
  end

protected

  def merge_params(options, params)
    if options[:params]
      options[:params] = options[:params].merge(params)
      options
    else
      options.merge(:params => params)
    end
  end

end
