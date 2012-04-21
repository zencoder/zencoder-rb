# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'zencoder/version'

Gem::Specification.new do |s|
  s.name        = "zencoder"
  s.version     = Zencoder::GEM_VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nathan Sutton", "Brandon Arbini"]
  s.email       = "info@zencoder.com"
  s.homepage    = "http://github.com/zencoder/zencoder-rb"
  s.summary     = "Zencoder <http://zencoder.com> integration library."
  s.description = "Zencoder <http://zencoder.com> integration library."
  s.rubyforge_project = "zencoder"
  s.add_dependency "multi_json", "~> 1.3"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "webmock"
  s.files        = Dir.glob("bin/**/*") + Dir.glob("lib/**/*") + %w(LICENSE README.markdown Rakefile)
  s.require_path = "lib"
end
