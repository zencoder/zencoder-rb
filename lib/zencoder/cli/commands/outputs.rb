module ZencoderCLI::Command
  class Outputs < Base

    provides "outputs", { "outputs:progress" => "Show output progress" }

    class << self

      def progress(args, global_options, command_options)
        output = Zencoder::Output.progress(args.shift, :base_url => Zencoder.base_url(global_options[:environment])).process_for_cli.body
        rows = []
        rows << ["State", output["state"].titleize]
        if output["state"] == "processing"
          rows << ["Event", output["current_event"].titleize]
          rows << ["Progress", output["progress"]]
        elsif output["state"] == "finished"
          rows << ["Progress", "100%"]
        end
        puts table([{ :value => "Output", :colspan => 2 }], *rows)
      end

    end
  end
end
