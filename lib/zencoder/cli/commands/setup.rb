require 'fileutils'

module ZencoderCLI::Command
  class Setup < Base
    extend ZencoderCLI::Helpers

    provides "setup", { "setup"        => "Caches authentication credentials",
                        "setup:delete" => "Removes the cached credentials" }

    class << self

      def run(args, options)
        display("Your Zencoder API Key: ", false)
        save_api_key(ask)
        display("Your API key has been saved to #{home_directory}/.zencoder/api-key.")
      end

      def delete(args, options)
        delete_setup
        display("#{home_directory}/.zencoder has been removed.")
      end


    protected

      def save_api_key(api_key)
        begin
          FileUtils.mkdir_p("#{home_directory}/.zencoder")
          File.open("#{home_directory}/.zencoder/api-key", 'w') do |f|
            f.puts api_key
          end
          FileUtils.chmod 0700, "#{home_directory}/.zencoder"
          FileUtils.chmod 0600, "#{home_directory}/.zencoder/api-key"
        rescue Exception => e
          delete_api_key
          raise e
        end
      end

      def delete_setup
        FileUtils.rm_rf("#{home_directory}/.zencoder") if File.exist?("#{home_directory}/.zencoder")
      end

    end
  end
end
