class Zencoder

  cattr_accessor :base_url
  cattr_accessor :api_key

  self.base_url = 'https://app.zencoder.com/api'

  def self.encode(content, format=nil)
    if content.is_a?(String)
      content
    elsif format.to_s == 'xml'
      content.to_xml
    else
      content.to_json
    end
  end

  def encode(content, format=nil)
    self.class.encode(content, format)
  end

  def self.decode(content, format=nil)
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

  def decode(content, format=nil)
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
