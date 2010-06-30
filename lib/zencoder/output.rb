class Zencoder
  class Output < Zencoder

    def self.progress(output_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.get("#{base_url}/outputs/#{output_id}/progress", merge_params(options, params))
    end

  end
end