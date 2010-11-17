# Standard Library
require 'cgi'
require 'net/https'
require 'timeout'

# ActiveSupport 3.0 with fallback to 2.0
begin
  require 'active_support/all' # Screw it
rescue LoadError
  require 'active_support' # JSON and XML parsing/encoding
end

# Zencoder
require 'zencoder/extensions'
require 'zencoder/zencoder'
require 'zencoder/http/net_http'
require 'zencoder/http/typhoeus'
require 'zencoder/http'
require 'zencoder/errors'
require 'zencoder/job'
require 'zencoder/output'
require 'zencoder/account'
require 'zencoder/notification'
require 'zencoder/response'
require 'zencoder/version'
