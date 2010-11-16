require 'fileutils'
require 'yaml'

module ZencoderCLI::Command
  class Setup < Base

    provides "setup", { "setup"        => "Caches authentication credentials",
                        "setup:delete" => "Removes cached credentials and plugins" }

    class << self

      def run(args, global_options, command_options)
        display("Enter Your Zencoder API Key: ", false)
        save_api_key(global_options[:environment], ask)
        display "Your API key has been saved to #{home_directory}/.zencoder/api-key."
      end

      def delete(args, global_options, command_options)
        if confirm
          delete_setup
          display "#{home_directory}/.zencoder has been removed."
        else
          display "Ok, nothing changed."
        end
      end


    protected

      def save_api_key(environment, api_key)
        environment = "production" if !environment || environment.blank?
        begin
          FileUtils.mkdir_p("#{home_directory}/.zencoder")
          if File.exist?("#{home_directory}/.zencoder/api-key")
            key_envs = YAML.load_file("#{home_directory}/.zencoder/api-key")
          else
            key_envs = {}
          end
          key_envs[environment] = api_key
          File.open("#{home_directory}/.zencoder/api-key", 'w') do |out|
            YAML.dump(key_envs, out)
          end
          FileUtils.chmod 0700, "#{home_directory}/.zencoder"
          FileUtils.chmod 0600, "#{home_directory}/.zencoder/api-key"
        rescue Exception => e
          raise e
        end
      end

      def delete_setup
        FileUtils.rm_rf("#{home_directory}/.zencoder") if File.exist?("#{home_directory}/.zencoder")
      end

    end
  end
end
