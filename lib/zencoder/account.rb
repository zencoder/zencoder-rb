module Zencoder
  class Account < Resource

    def self.create(params={}, options={})
      post("/account", params, options)
    end

    def self.details(options={})
      get("/account", options)
    end

    def self.integration(options={})
      put("/account/integration", nil, options)
    end

    def self.live(options={})
      put("/account/live", nil, options)
    end

  end
end
