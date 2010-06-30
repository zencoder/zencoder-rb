class Zencoder
  class Notification < Zencoder

    def self.list(options={})
      params = {:api_key  => options.delete(:api_key) || api_key,
                :page     => options.delete(:page) || 1,
                :per_page => options.delete(:per_page) || 50 }

      Zencoder::HTTP.get("#{base_url}/notifications", merge_params(options, params))
    end

  end
end
