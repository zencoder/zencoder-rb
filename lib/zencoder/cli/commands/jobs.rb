module ZencoderCLI::Command
  class Jobs < Base

    provides "jobs", { "jobs:list"     => { :description => "Lists the most recent jobs",
                                            :options => proc{|t|
                                              t.opt :number, "Number of jobs returned per page. Default 10.", :type => Integer
                                              t.opt :page,   "Jobs page number. Default 1.", :type => Integer
                                            }},
                       "jobs:show"     => "Show job details by ID",
                       "jobs:resubmit" => "Resubmit a job by ID",
                       "jobs:cancel"   => "Cancels a job by ID",
                       "jobs:delete"   => "Deletes a job by ID" }

    class << self

      def list(args, global_options, command_options)
        jobs = Zencoder::Job.list(:base_url => Zencoder.base_url(global_options[:environment]), :per_page => command_options[:number] || 10, :page => command_options[:page] || 1).body
        if jobs.any?
          jobs_table = table do |t|
            t.headings = ["ID", "Created", "State"]
            jobs.each do |job|
              t << [job["job"]["id"], format_date(job["job"]["created_at"]), job["job"]["state"].titleize]
            end
          end
          puts jobs_table
        else
          puts "No jobs found."
        end
      end

      def show(args, global_options, command_options)
        job = Zencoder::Job.details(args.shift, :base_url => Zencoder.base_url(global_options[:environment])).body["job"]
        rows = []
        rows << ["ID", job["id"]]
        rows << ["Submitted", format_date(job["created_at"])]
        rows << ["State", job["state"].titleize]
        puts table([{ :value => "Job", :colspan => 2 }], *rows)
      end

      def resubmit(args, global_options, command_options)
        response = Zencoder::Job.resubmit(args.shift, :base_url => Zencoder.base_url(global_options[:environment]))
        puts "Job resubmitted."
      end

      def cancel(args, global_options, command_options)
        response = Zencoder::Job.cancel(args.shift, :base_url => Zencoder.base_url(global_options[:environment]))
        puts "Job cancelled."
      end

      def delete(args, global_options, command_options)
        response = Zencoder::Job.delete(args.shift, :base_url => Zencoder.base_url(global_options[:environment]))
        puts "Job deleted."
      end

    end
  end
end
