module ZencoderCLI::Command
  class Plugins < Base

    provides "plugins", { "plugins:list" => "Lists installed plugins",
                          "plugins:install" => "Install a plugin via URL",
                          "plugins:uninstall" => "Uninstall a plugin" }

    class << self

      def list(args, global_options, command_options)
        if ZencoderCLI::Plugin.list.any?
          puts "The following plugins are installed:"
          ZencoderCLI::Plugin.list.each do |plugin|
            display "* #{plugin}"
          end
        else
          display "There are no plugins installed."
        end
      end

      def install(args, global_options, command_options)
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

      def uninstall(args, global_options, command_options)
        plugin = ZencoderCLI::Plugin.new(args.shift)
        plugin.uninstall
        display "#{plugin} uninstalled."
      end

    end
  end
end
