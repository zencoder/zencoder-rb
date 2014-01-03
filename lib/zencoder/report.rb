module Zencoder
  class Report < Resource

    def self.minutes(options={})
      get("/reports/minutes", merge_params(*extract_params(options)))
    end

    def self.all(options={})
      get("/reports/all", merge_params(*extract_params(options)))
    end

    def self.live(options={})
      get("/reports/live", merge_params(*extract_params(options)))
    end

    def self.vod(options={})
      get("/reports/vod", merge_params(*extract_params(options)))
    end


  protected

    def self.extract_params(options={})
      options = options.dup
      params = {
        :from => options.delete(:from),
        :to   => options.delete(:to),
        :grouping => options.delete(:grouping)
      }

      return options, params.delete_if { |k, v| v.nil? }
    end

  end
end
