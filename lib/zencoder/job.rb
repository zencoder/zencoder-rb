class Zencoder::Job

  attr_accessor :params

  def initialize(params={})
    if params.is_a?(Hash)
      self.params = params
    else
      raise Zencoder::ArgumentError, 'Zencoder::Job must be initialized with a Hash'
    end
  end

end
