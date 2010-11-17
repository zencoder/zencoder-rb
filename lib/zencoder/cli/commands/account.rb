module ZencoderCLI::Command
  class Account < Base

    provides "account", { "account:show" => "Show account information",
                          "account:integration" => "Put your account in integration mode",
                          "account:live" => "Take your account out of integration mode" }

    class << self

      def show(args, global_options, command_options)
        account = Zencoder::Account.details(:base_url => Zencoder.base_url(global_options[:environment])).body
        rows = []
        rows << ["Minutes Used", account["minutes_used"]]
        rows << ["Minutes Included", account["minutes_included"]]
        rows << ["Account State", account["account_state"].titleize]
        rows << ["Billing State", account["billing_state"].titleize]
        rows << ["Plan", account["plan"]]
        rows << ["Integration Mode", account["integration_mode"] ? "YES" : "NO"]
        puts table([{ :value => "Account", :colspan => 2 }], *rows)
      end

      def integration(args, global_options, command_options)
        response = Zencoder::Account.integration(:base_url => Zencoder.base_url(global_options[:environment]))
        if response.success?
          puts "Your account is now in integration mode."
        else
          puts "There was an unexpected problem."
        end
      end

      def live(args, global_options, command_options)
        response = Zencoder::Account.live(:base_url => Zencoder.base_url(global_options[:environment]))
        if response.success?
          puts "Your account is now able to process live jobs."
        else
          puts "You cannot turn off integration mode for this account."
        end
      end

    end
  end
end
