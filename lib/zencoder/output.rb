module Zencoder
  class Output < Resource

    def self.progress(output_id, options={})
      get("/outputs/#{output_id}/progress", options)
    end

  end
end
