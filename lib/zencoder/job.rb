class Zencoder
  class Job < Zencoder

    def self.create(params={}, options={})
      params_with_api_key = {:api_key => api_key}.merge(decode(params, options[:format]))
      HTTP.post("#{base_url}/jobs",
                           encode(params_with_api_key, options[:format]),
                           options)
    end

    def self.list(options={})
      params = {:api_key  => options.delete(:api_key) || api_key,
                :page     => options.delete(:page) || 1,
                :per_page => options.delete(:per_page) || 50 }

      HTTP.get("#{base_url}/jobs", merge_params(options, params))
    end

    def self.details(job_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.get("#{base_url}/jobs/#{job_id}", merge_params(options, params))
    end

    def self.resubmit(job_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.get("#{base_url}/jobs/#{job_id}/resubmit", merge_params(options, params))
    end

    def self.cancel(job_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.get("#{base_url}/jobs/#{job_id}/cancel", merge_params(options, params))
    end

    def self.delete(job_id, options={})
      params = {:api_key => options.delete(:api_key) || api_key}
      HTTP.delete("#{base_url}/jobs/#{job_id}", merge_params(options, params))
    end

  end
end
