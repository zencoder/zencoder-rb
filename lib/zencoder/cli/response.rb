class Zencoder
  class HTTP < Zencoder

    def process_with_cli(http_response)
      response = process_without_cli(http_response)
      if response.success?
        response
      else
        if response.errors.any?
          puts "Errors:\n#{response.errors.map{|error| "* "+error }.join("\n")}"
        else
          puts "ERROR\n-----\n\n#{response.body}\n\nHTTP Response Code\n------------------\n#{response.code}"
        end
        exit(1)
      end
    end
    alias_method_chain :process, :cli

  end
end
