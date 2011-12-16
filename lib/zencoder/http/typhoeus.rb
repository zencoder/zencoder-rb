module Zencoder
  class HTTP
    class Typhoeus

      def self.post(url, options={})
        perform(:post, url, options)
      end

      def self.put(url, options={})
        perform(:put, url, options)
      end

      def self.get(url, options={})
        perform(:get, url, options)
      end

      def self.delete(url, options={})
        perform(:delete, url, options)
      end

      def self.perform(method, url, options={})
        if options.delete(:skip_ssl_verify)
          options[:disable_ssl_peer_verification] = true
        end

        ::Typhoeus::Request.send(method, url, options)
      end

    end
  end
end
