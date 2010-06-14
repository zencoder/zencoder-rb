module Zencoder::HTTP::Typhoeus

  def self.post(url, options)
    ::Typhoeus::Request.post(url, options)
  end

  def self.put(url, options)
    ::Typhoeus::Request.put(url, options)
  end

  def self.get(url, options)
    ::Typhoeus::Request.get(url, options)
  end

  def self.delete(url, options)
    ::Typhoeus::Request.delete(url, options)
  end

end
