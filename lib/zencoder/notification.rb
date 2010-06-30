module Zencoder
  module Notification

    extend Zencoder

    def self.list(options={})
      params = {:api_key  => options.delete(:api_key) || Zencoder.api_key,
                :page     => options.delete(:page) || 1,
                :per_page => options.delete(:per_page) || 50 }

      Zencoder::HTTP.get("#{Zencoder.base_url}/notifications", merge_params(options, params))
    end

  end
end
