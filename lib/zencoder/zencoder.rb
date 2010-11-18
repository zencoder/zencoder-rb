module Zencoder

  mattr_writer :api_key
  mattr_writer :base_url

  self.api_key  = nil
  self.base_url = 'https://app.zencoder.com/api'

  def self.api_key
    @@api_key || ENV['ZENCODER_API_KEY']
  end

  def self.base_url(env=nil)
    @@base_url
  end

end
