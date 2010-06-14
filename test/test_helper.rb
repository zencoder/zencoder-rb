require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'webmock'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'zencoder'
require 'typhoeus'

class Test::Unit::TestCase
  include WebMock
end
