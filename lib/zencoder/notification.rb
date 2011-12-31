module Zencoder
  class Notification < Resource

    def self.list(options={})
      options = options.dup
      params  = {:page     => options.delete(:page) || 1,
                 :per_page => options.delete(:per_page) || 50 }

      get("/notifications", merge_params(options, params))
    end

  end
end
