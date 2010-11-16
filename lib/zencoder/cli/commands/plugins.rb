module ZencoderCLI::Command
  class Plugins < Base
    extend ZencoderCLI::Helpers

    provides "plugins", { "plugins:list" => "Lists installed plugins" }

    class << self

      def list(args, options)
        if ZencoderCLI::Plugin.list.any?
          ZencoderCLI::Plugin.list.each do |plugin|
            display plugin
          end
        else
          display "There are no plugins installed."
        end
      end

      def install(args, options)
        plugin = ZencoderCLI::Plugin.new(args.shift)
        if plugin.install
          begin
            ZencoderCLI::Plugin.load_plugin(plugin.name)
          rescue Exception => e
            installation_failed(plugin, e.message)
          end
          display "#{plugin} installed."
        else
          error "Could not install #{plugin}. Please check the URL and try again."
        end
      end

      # def uninstall(args, options)
      #   plugin = ZencoderCLI::Plugin.new(args.shift)
      #   plugin.uninstall
      #   display "#{plugin} uninstalled."
      # end

    end
  end
end
