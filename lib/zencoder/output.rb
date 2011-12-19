module Zencoder
  class Output < Resource

    def self.details(output_id, options={})
      get("/outputs/#{output_id}", options)
    end

    def self.progress(output_id, options={})
      get("/outputs/#{output_id}/progress", options)
    end

  end
end
