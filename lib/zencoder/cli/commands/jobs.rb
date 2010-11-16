module ZencoderCLI::Command
  class Jobs < Base
    extend ZencoderCLI::Helpers

    provides "jobs", { "jobs:list" => "Lists the most recent jobs" }

    class << self

      def list(args, options)
        jobs = Zencoder::Job.list(:per_page => options[:number] || 10, :page => options[:page] || 1).body
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
