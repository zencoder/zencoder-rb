module ZencoderCLI::Command
  class Jobs < Base

    provides "jobs", { "jobs:list" => "Lists the most recent jobs" }

    class << self

      def list(args, global_options, command_options)
        jobs = Zencoder::Job.list(:base_url => Zencoder.base_url(global_options[:environment]), :per_page => command_options[:number] || 10, :page => command_options[:page] || 1).body
        jobs_table = table do |t|
          t.headings = ["ID", "Created", "State"]
          jobs.each do |job|
            t << [job["job"]["id"], format_date(job["job"]["created_at"]), job["job"]["state"].titleize]
          end
        end
        puts jobs_table
      end

    end
  end
end
