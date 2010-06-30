class Zencoder

  cattr_accessor :base_url
  cattr_accessor :api_key

  self.base_url = 'https://app.zencoder.com/api'

  def self.encode(content, format)
    if content.is_a?(String)
      content
    elsif format.to_s == 'xml'
      content.to_xml
    elsif
      content.to_json
    end
  end

  def encode(content, format)
    self.class.encode(content, format)
  end

  def self.decode(content, format)
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

  def decode(content, format)
    self.class.decode(content, format)
  end


protected

  def self.merge_params(options, params)
    if options[:params]
      options[:params] = options[:params].merge(params)
      options
    else
      options.merge(:params => params)
    end
  end

end
