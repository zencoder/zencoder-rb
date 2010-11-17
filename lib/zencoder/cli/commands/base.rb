module ZencoderCLI::Command
  class Base
    extend ZencoderCLI::Helpers

    class << self

      def provides(name, commands={})
        ZencoderCLI::Command.commands.merge!({ name => commands })
      end

    end
  end
end
