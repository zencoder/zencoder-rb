class Zencoder::Error < StandardError
end

class Zencoder::ArgumentError < Zencoder::Error
end

class Zencoder::HTTPSError < Zencoder::Error
end
