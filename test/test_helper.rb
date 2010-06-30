require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
require 'mocha/integration/test_unit' # Bundler load-order hax

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'zencoder'

begin
  require 'typhoeus'
rescue LoadError # doesn't work for all ruby versions
  puts
  puts 'Typhoeus not loaded. If your ruby version supports native extensions'
  puts 'then consider installing it.'
  puts
  puts '   gem install typhoeus'
  puts
end

class Test::Unit::TestCase
  include WebMock
end
