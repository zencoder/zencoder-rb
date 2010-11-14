require 'zencoder/cli/helpers'
require 'zencoder/cli/plugin'

Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each { |c| require c }

module ZencoderCLI
  module Command
    extend ZencoderCLI::Helpers
    class << self

      def run(command, args, global_options={}, command_options={})
        require_authentication unless command[/^setup/]
        command.match(/([^:]+):?(.*)?/)
        klass = "ZencoderCLI::Command::#{$1.titleize}".constantize
        method_name = $2.present? ? $2 : :run
        if klass.respond_to?(method_name)
          klass.send(method_name, args, command_options)
        else
          raise UnknownCommandName
        end
      rescue UnknownCommandName, NameError => e
        if e.class == UnknownCommandName || e.message[/uninitialized constant ZencoderCLI::Command::#{$1.titleize}/]
          error "There is no command named #{command}. Use --help for more information."
        else
          raise e
        end
      end


    protected

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


module ZencoderCLI::Command
  class UnknownCommandName < StandardError; end
end
