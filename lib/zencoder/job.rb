class Zencoder::Job

  attr_accessor :params

  def initialize(params={})
    self.params = params
  end

end
