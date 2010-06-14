module Zencoder

  class << self
    attr_accessor :base_url
    attr_accessor :api_key
  end

  self.base_url = 'https://app.zencoder.com/api'


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
