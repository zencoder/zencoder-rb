module Zencoder
  class Report < Resource

    def self.minutes(options={})
      get("/reports/minutes", options)
    end

  end
end
