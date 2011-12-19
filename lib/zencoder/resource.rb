module Zencoder
  class Resource

    include Zencoder::Serializer

    def self.api_key
      Zencoder.api_key
    end

    def self.base_url
      Zencoder.base_url
    end

    def self.post(path, params={}, options={})
      url     = url_for(path, options)
      body    = encode(params, options[:format])
      options = add_api_key_header(options)
      HTTP.post(url, body, options)
    end

    def self.put(path, params={}, options={})
      body    = encode(params, options[:format])
      url     = url_for(path, options)
      options = add_api_key_header(options)
      HTTP.put(url, body, options)
    end

    def self.get(path, options={})
      url     = url_for(path, options)
      options = add_api_key_header(options)
      HTTP.get(url, options)
    end

    def self.delete(path, options={})
      url     = url_for(path)
      options = add_api_key_header(options)
      HTTP.delete(url, options)
    end


  protected

    def self.url_for(path, options={})
      File.join((options[:base_url] || base_url).to_s, path.to_s)
    end

    def self.add_api_key_header(options)
      effective_api_key = options.delete(:api_key) || api_key

      if effective_api_key
        options[:headers] ||= {}
        options[:headers]["Zencoder-Api-Key"] = effective_api_key
      end

      options
    end

    def self.apply_api_key(params, format=nil)
      if api_key
        decoded_params = decode(params, format).with_indifferent_access

        if decoded_params[:api_request]
          decoded_params[:api_request] = decoded_params[:api_request].with_indifferent_access
        end

        if format.to_s == 'xml'
          if !(decoded_params[:api_request] && decoded_params[:api_request][:api_key])
            decoded_params[:api_request] ||= {}.with_indifferent_access
            decoded_params[:api_request][:api_key] = api_key
          end
        else
          decoded_params['api_key'] = api_key unless decoded_params['api_key']
        end

        decoded_params
      else
        params
      end
    end

    def self.merge_params(options, params)
      if options[:params]
        options[:params] = options[:params].merge(params)
        options
      else
        options.merge(:params => params)
      end
    end

  end
end
