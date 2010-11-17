require 'yaml'

module ZencoderCLI
  module Auth
    extend ZencoderCLI::Helpers
    class << self

      def require_authentication(env)
        Zencoder.api_key ||= retrieve_api_key(env)
      end

      def retrieve_api_key(env)
        env = "production" if !env || env.blank?
        if File.exist?("#{home_directory}/.zencoder/api-key")
          keys = YAML.load_file("#{home_directory}/.zencoder/api-key")
          if keys[env].present?
            keys[env]
          else
            error "No API found for the #{env} environment. Either set the environment variable ZENCODER_API_KEY or run `zencoder setup`."
          end
        else
          error "No API keys found. Either set the environment variable ZENCODER_API_KEY or run `zencoder setup`."
        end
      end

    end
  end
end
