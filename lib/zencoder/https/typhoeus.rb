module Zencoder::HTTPS::Typhoeus

  def self.post(url, options)
    ::Typhoeus::Request.post(url, options)
  end

end
