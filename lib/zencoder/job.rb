module Zencoder
  class Job < Resource

    def self.create(params={}, options={})
      post("/jobs", params, options)
    end

    def self.list(options={})
      params = { :page     => options.delete(:page) || 1,
                 :per_page => options.delete(:per_page) || 50,
                 :state    => options.delete(:state) }

      get("/jobs", merge_params(options, params))
    end

    def self.details(job_id, options={})
      get("/jobs/#{job_id}", options)
    end

    def self.progress(job_id, options={})
      get("/jobs/#{job_id}/progress", options)
    end

    def self.resubmit(job_id, options={})
      put("/jobs/#{job_id}/resubmit", nil, options)
    end

    def self.cancel(job_id, options={})
      put("/jobs/#{job_id}/cancel", nil, options)
    end

  end
end
