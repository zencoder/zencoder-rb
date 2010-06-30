module Zencoder
  module Output

    extend Zencoder

    def self.progress(output_id, options={})
      params = {:api_key => options.delete(:api_key) || Zencoder.api_key}
      Zencoder::HTTP.get("#{Zencoder.base_url}/outputs/#{output_id}/progress", merge_params(options, params))
    end

  end
end