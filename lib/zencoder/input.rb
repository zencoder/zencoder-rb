module Zencoder
  class Input < Resource

    def self.details(input_id, options={})
      get("/inputs/#{input_id}", options)
    end

    def self.progress(input_id, options={})
      get("/inputs/#{input_id}/progress", options)
    end

  end
end
