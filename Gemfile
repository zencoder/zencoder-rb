source 'https://rubygems.org'

gem "multi_json"

group :test do
  gem "shoulda", "2.11.3"
  gem "mocha"
  gem "webmock", "~>1.6.0"
end

group :development do
  gem "jruby-openssl", :platforms => :jruby
  gem "typhoeus",      :platforms => [:mri_18, :mri_19, :mri_20, :mri_21]
end

group :test, :development do
  gem "rake"
end
