module Zencoder
  class Output < Resource

    def self.progress(output_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.get("#{options[:base_url] || base_url}/outputs/#{output_id}/progress", merge_params(options, params))
    end

  end
end
