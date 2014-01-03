source 'https://rubygems.org'

gem "multi_json"
gem "rake"

group :test do
  gem "shoulda", "2.11.3"
  gem "activesupport", "3.2.16"
  gem "mocha"
  gem "webmock", "~>1.6.0"
end

group :development do
  gem "jruby-openssl", :platforms => :jruby
  gem "ruby-debug",    :platforms => :mri_18
  gem "ruby-debug19",  :platforms => :mri_19
  gem "byebug",        :platforms => :mri_20
  gem "typhoeus",      :platforms => [:mri_18, :mri_19, :mri_20]
end
