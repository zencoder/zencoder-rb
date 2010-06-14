module Zencoder::Account

  extend Zencoder

  def self.create(params={}, options={})
    Zencoder::HTTP.post("#{Zencoder.base_url}/account", params.to_json, options)
  end

  def self.details(options={})
    params = {:api_key  => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/account", merge_params(options, params))
  end

  def self.integration(options={})
    params = {:api_key  => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/account/integration", merge_params(options, params))
  end

  def self.live(options={})
    params = {:api_key  => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/account/live", merge_params(options, params))
  end

end
