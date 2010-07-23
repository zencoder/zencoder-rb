class Hash
  def recursive_with_indifferent_access
    hash = with_indifferent_access
    hash.each do |key, value|
      if value.is_a?(Hash)
        hash[key] = value.recursive_with_indifferent_access
      end
    end
    return hash
  end
end
