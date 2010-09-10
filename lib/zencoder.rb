# Standard Library
require 'cgi'
require 'net/https'
require 'timeout'

# Gems
require 'active_support' # JSON and XML parsing/encoding

# ActiveSupport 3.0
begin
  require 'active_support/core_ext/class'
  require 'active_support/core_ext/hash'
  require 'active_support/json'
  require 'active_support/xml'
rescue LoadError
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
