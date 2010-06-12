class Zencoder::Job

  attr_accessor :params

  def initialize(params={})
    if params.is_a?(Hash)
      self.params = params
    else
      raise Zencoder::ArgumentError, "Zencoder::Job must be initialized with a Hash. Was initialized with #{params}"
    end
  end

  def create(options={})
    Zencoder::HTTPS.post('https://api.zencoder.com/api/jobs', params.to_json, options)
  end

  def self.create(params={}, options={})
    Zencoder::Job.new(params).create(options)
  end

end
