module Zencoder
  class Report < Resource

    def self.minutes(options={})
      options = options.dup
      params = {
        :from => options.delete(:from),
        :to   => options.delete(:to),
        :grouping => options.delete(:grouping)
      }

      params.delete_if { |k, v| v.nil? }

      get("/reports/minutes", merge_params(options, params))
    end

  end
end
