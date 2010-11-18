module Zencoder
  class Account < Base

    def self.create(params={}, options={})
      HTTP.post("#{options[:base_url] || base_url}/account", encode(params, options[:format]), options)
    end

    def self.details(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      HTTP.get("#{options[:base_url] || base_url}/account", merge_params(options, params))
    end

    def self.integration(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      HTTP.get("#{options[:base_url] || base_url}/account/integration", merge_params(options, params))
    end

    def self.live(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      HTTP.get("#{options[:base_url] || base_url}/account/live", merge_params(options, params))
    end

  end
end
