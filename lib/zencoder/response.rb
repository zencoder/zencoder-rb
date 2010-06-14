class Zencoder::Response

  attr_accessor :code, :body, :raw_body, :raw_response

  def initialize(options={})
    options.each do |k, v|
      send("#{k}=", v) if respond_to?("#{k}=")
    end
  end

  def success?
    code.to_i > 199 && code.to_i < 300
  end

  def errors
    if body.is_a?(Hash)
      Array(body['errors']).compact
    else
      []
    end
  end

  def job_id
    if body.is_a?(Hash)
      body['id']
    end
  end

  def output_ids
    if body.is_a?(Hash) && body['outputs'].is_a?(Array) && body['outputs'].all?{|o| o.is_a?(Hash) }
      body['outputs'].map{|o| o['id'] }.compact
    else
      []
    end
  end

  def output_id
    output_ids[0]
  end

end
