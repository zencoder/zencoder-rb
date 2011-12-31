module Zencoder

  class << self
    attr_accessor :api_key, :base_url
  end

  self.api_key  = nil
  self.base_url = 'https://app.zencoder.com/api/v2'

  def self.api_key
    @api_key || ENV['ZENCODER_API_KEY']
  end

  def self.base_url(env=nil)
    @base_url
  end

end
