module ZencoderCLI
  module Command

    class UnknownCommandName < RuntimeError; end

    mattr_accessor :commands
    self.commands = {}

    class << self

      def run(command, args, global_options={}, command_options={})
        ZencoderCLI::Auth.require_authentication unless command[/^setup/]
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

    end
  end
end


Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each { |c| require c }
