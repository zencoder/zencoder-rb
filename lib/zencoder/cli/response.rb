class Zencoder
  class Response < Zencoder

    def process_for_cli
      if success?
        self
      else
        if errors.any?
          puts "Errors:\n#{errors.map{|error| "* "+error }.join("\n")}"
        else
          puts "ERROR\n-----\n\n#{body}\n\nHTTP Response Code\n------------------\n#{code}"
        end
        exit(1)
      end
    end

  end
end
