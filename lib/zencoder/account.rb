class Zencoder
  class Account < Zencoder

    def self.create(params={}, options={})
      Zencoder::HTTP.post("#{base_url}/account", encode(params, options[:format]), options)
    end

    def self.details(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      Zencoder::HTTP.get("#{base_url}/account", merge_params(options, params))
    end

    def self.integration(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      Zencoder::HTTP.get("#{base_url}/account/integration", merge_params(options, params))
    end

    def self.live(options={})
      params = {:api_key  => options.delete(:api_key) || api_key}
      Zencoder::HTTP.get("#{base_url}/account/live", merge_params(options, params))
    end

  end
end
