module Zencoder::Job

  extend Zencoder

  def self.create(params={}, options={})
    params_with_api_key = {:api_key => Zencoder.api_key}.merge(params)
    Zencoder::HTTP.post("#{Zencoder.base_url}/jobs",
                         MultiJson.encode(params_with_api_key),
                         options)
  end

  def self.list(options={})
    params = {:api_key  => options.delete(:api_key) || Zencoder.api_key,
              :page     => options.delete(:page) || 1,
              :per_page => options.delete(:per_page) || 50 }

    Zencoder::HTTP.get("#{Zencoder.base_url}/jobs", merge_params(options, params))
  end

  def self.details(job_id, options={})
    params = {:api_key => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/jobs/#{job_id}", merge_params(options, params))
  end

  def self.resubmit(job_id, options={})
    params = {:api_key => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/jobs/#{job_id}/resubmit", merge_params(options, params))
  end

  def self.cancel(job_id, options={})
    params = {:api_key => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.get("#{Zencoder.base_url}/jobs/#{job_id}/cancel", merge_params(options, params))
  end

  def self.delete(job_id, options={})
    params = {:api_key => options.delete(:api_key) || Zencoder.api_key}
    Zencoder::HTTP.delete("#{Zencoder.base_url}/jobs/#{job_id}", merge_params(options, params))
  end

end
