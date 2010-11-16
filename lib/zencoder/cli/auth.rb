module ZencoderCLI
  module Auth
    extend ZencoderCLI::Helpers
    class << self

      def require_authentication
        Zencoder.api_key ||= retrieve_api_key
      end

      def retrieve_api_key
        if File.exist?("#{home_directory}/.zencoder/api-key")
          File.read("#{home_directory}/.zencoder/api-key")
        else
          error "No API key found. Either set the environment variable ZENCODER_API_KEY or run `zencoder setup`."
        end
      end

    end
  end
end
