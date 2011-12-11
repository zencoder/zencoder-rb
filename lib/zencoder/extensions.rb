unless Hash.method_defined?(:recursive_with_indifferent_access)
  class Hash
    def recursive_with_indifferent_access
      hash = with_indifferent_access

      hash.each do |key, value|
        if value.is_a?(Hash) || value.is_a?(Array)
          hash[key] = value.recursive_with_indifferent_access
        end
      end

      hash
    end
  end
end

unless Array.method_defined?(:recursive_with_indifferent_access)
  class Array
    def recursive_with_indifferent_access
      array = dup

      array.each_with_index do |value, index|
        if value.is_a?(Hash) || value.is_a?(Array)
          array[index] = value.recursive_with_indifferent_access
        end
      end

      array
    end
  end
end
