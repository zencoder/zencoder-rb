module Zencoder
  class Resource

    include Zencoder::Serializer

    def self.api_key
      Zencoder.api_key
    end

    def self.base_url
      Zencoder.base_url
    end


  protected

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
