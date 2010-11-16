module ZencoderCLI::Command
  class Base
    class << self

      def provides(name, commands={})
        ZencoderCLI::Command.commands.merge!({ name => commands })
      end

    end
  end
end
