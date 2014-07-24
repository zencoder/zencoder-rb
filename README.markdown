# Zencoder

The gem for interacting with the API on [Zencoder](http://zencoder.com).

See [http://zencoder.com/docs/api](http://zencoder.com/docs/api) for more details on the API.

Tested on the following versions of Ruby:

* Ruby 1.8.6-p420
* Ruby 1.8.7-p249
* Ruby 1.8.7-p352
* Ruby 1.9.2-p290
* Ruby 1.9.3-p0
* Ruby 2.0.0-p353
* Rubinius 2.0.0dev
* jRuby 1.6.5

## 2.5 WARNING!!!

Version 2.5 brings a single, significant change to the gem which you should be aware of:

* __The Zencoder SSL CA chain is no longer bundled.__ Our intermediate SSL cert is expiring and the necessary file may change in the future. You can now specify the CA file or CA path along with the request.

[We recommend installing a CA bundle (probably cURL's) in your OS and have ruby use that.](http://mislav.uniqpath.com/2013/07/ruby-openssl/)

## v2.4 WARNING!!!

Version 2.4 brings some significant changes to the gem, ones which you should be aware of:

* __Removed dependency on `activesupport`.__ This means that the keys of your hashes should all be symbols except in the case of HTTP headers.
* __Added dependency on `multi_json`__. This gem allows encoding and decoding to and from JSON without all the baggage of `activesupport`.
* __Removed support for XML requests.__ Since we're doing all the encoding and decoding in the gem, it didn't make sense to support it any longer. You could still conceivably do this with the gem, but you'd need to encode and decode to and from XML yourself and pass appropriate headers. Let us know if this is a problem for you.
* __Using header authentication by default.__ Zencoder has always allowed the passing of the API key as an HTTP header (`Zencoder-Api-Key`), but in this library we've traditionally merged it in with your requests. In at least one case this would result in messy deserialization and serialization of parameters. Using this alternative authentication method clears up this problem.
* __Some actions only work on future versions of the API.__ See the section titled `APIv2` below.
* __Now defaults to API v2.__ If you'd like to continue using API v1, you should change the base_url as outlined in the section titled `APIv2` below.
* __The Zencoder SSL CA chain is now bundled.__ Previously when you used the default HTTP backend (Net::HTTP), we would try to detect the CA path on your system and use it. This led to some frustration for some users and was generally unreliable. We now bundle our SSL CA chain in the library which should make integration easier. Please note that if you were using `Zencoder::HTTP::NetHTTP.root_cert_paths` or `Zencoder::HTTP::NetHTTP.skip_setting_root_cert_path`, they have been removed.

## APIv2

With the release of version two of the Zencoder API, there are some new methods available to you.

* Zencoder::Job.progress(job\_id)
* Zencoder::Input.details(input\_id)
* Zencoder::Input.progress(input\_id)
* Zencoder::Output.details(output\_id)
* Zencoder::Report.minutes(:from => "2011-01-01", :to => "2011-03-01")
* Zencoder::Report.all(:from => "2011-01-01", :to => "2011-03-01")
* Zencoder::Report.live(:from => "2011-01-01", :to => "2011-03-01")
* Zencoder::Report.vod(:from => "2011-01-01", :to => "2011-03-01")

These new methods will not work with older versions of the API. Please see the [Zencoder documentation](https://app.zencoder.com/docs) and our [blog post on the subject](http://blog.zencoder.com/2012/01/05/announcing-zencoder-api-v2/) for more information on APIv2.

If you'd like to use the new version of the library but continue using APIv1 until you work through any integration troubles, you can do the following:

```ruby
Zencoder.base_url = "https://app.zencoder.com/api/v1"
```

## Getting Started

To install the gem on Rails, simply add it to your Gemfile:

```ruby
gem "zencoder", "~> 2.0"
```

The first thing you'll need to interact with the Zencoder API is your API key. You can use your API key in one of three ways. The first and easiest is to set it and forget it on the Zencoder module like so:

```ruby
Zencoder.api_key = 'abcd1234'
```

Alternatively, you can use an environment variable:

```ruby
ENV['ZENCODER_API_KEY'] = 'abcd1234'
```

You can also pass your API key in every request, but who wants to do that?

## Responses

All calls in the Zencoder library either raise Zencoder::HTTPError or return a Zencoder::Response.

A Zencoder::Response can be used as follows:

```ruby
response = Zencoder::Job.list
response.success?     # => true if the response code was 200 through 299
response.code         # => 200
response.body         # => the JSON-parsed body or raw body if unparseable
response.raw_body     # => the body pre-JSON-parsing
response.raw_response # => the raw Net::HTTP or Typhoeus response (see below for how to use Typhoeus)
response.request      # => the request object, you can inspect it if you need details on the request to debug it
```

### Parameters

When sending API request parameters you can specify them as a non-string object, which we'll then serialize to JSON:

```ruby
Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
```

Or you can specify them as a string, which we'll just pass along as the request body:

```ruby
Zencoder::Job.create('{"input": "s3://bucket/key.mp4"}')
```

## Jobs

There's more you can do on jobs than anything else in the API. The following methods are available: `list`, `create`, `details`, `resubmit`, `cancel`, `delete`.

### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Job creation API call on Zencoder](http://zencoder.com/docs/api/#encoding-job). We'll auto-populate your API key if you've set it already.

```ruby
Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
Zencoder::Job.create({:input => 's3://bucket/key.mp4',
                      :outputs => [{:label => 'vp8 for the web',
                                    :url => 's3://bucket/key_output.webm'}]})
Zencoder::Job.create({:input => 's3://bucket/key.mp4', :api_key => 'abcd1234'})
```

This returns a Zencoder::Response object. The body includes a Job ID, and one or more Output IDs (one for every output file created).

```ruby
response = Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
response.code            # => 201
response.body['id']      # => 12345
```

### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass two parameters to control the paging: `page` and `per_page`.

```ruby
Zencoder::Job.list
Zencoder::Job.list(:per_page => 10)
Zencoder::Job.list(:per_page => 10, :page => 2)
Zencoder::Job.list(:per_page => 10, :page => 2, :api_key => 'abcd1234')
```

### details

The number passed to `details` is the ID of a Zencoder job.

```ruby
Zencoder::Job.details(1)
Zencoder::Job.details(1, :api_key => 'abcd1234')
```

### progress

The number passed to `progress` is the ID of a Zencoder job.

```ruby
Zencoder::Job.progress(1)
Zencoder::Job.progress(1, :api_key => 'abcd1234')
```

### resubmit

The number passed to `resubmit` is the ID of a Zencoder job.

```ruby
Zencoder::Job.resubmit(1)
Zencoder::Job.resubmit(1, :api_key => 'abcd1234')
```

### cancel

The number passed to `cancel` is the ID of a Zencoder job.

```ruby
Zencoder::Job.cancel(1)
Zencoder::Job.cancel(1, :api_key => 'abcd1234')
```

### delete

The number passed to `delete` is the ID of a Zencoder job.

```ruby
Zencoder::Job.delete(1)
Zencoder::Job.delete(1, :api_key => 'abcd1234')
```

## Inputs

### details

The number passed to `details` is the ID of a Zencoder input.

```ruby
Zencoder::Input.details(1)
Zencoder::Input.details(1, :api_key => 'abcd1234')
```

### progress

The number passed to `progress` is the ID of a Zencoder input.

```ruby
Zencoder::Input.progress(1)
Zencoder::Input.progress(1, :api_key => 'abcd1234')
```

## Outputs

### details

The number passed to `details` is the ID of a Zencoder output.

```ruby
Zencoder::Output.details(1)
Zencoder::Output.details(1, :api_key => 'abcd1234')
```

### progress

*Important:* the number passed to `progress` is the output file ID, not the Job ID.

```ruby
Zencoder::Output.progress(1)
Zencoder::Output.progress(1, :api_key => 'abcd1234')
```

## Notifications

### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass three parameters to control the paging: `page`, `per_page`, and `since_id`. Passing `since_id` will return notifications for jobs created after the job with the given ID.

```ruby
Zencoder::Notification.list
Zencoder::Notification.list(:per_page => 10)
Zencoder::Notification.list(:per_page => 10, :page => 2)
Zencoder::Notification.list(:per_page => 10, :page => 2, :since_id => 20)
Zencoder::Notification.list(:api_key => 'abcd1234')
```

## Accounts

### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Account creation API call on Zencoder](http://zencoder.com/docs/api/#accounts). No API key is required for this call, of course.

```ruby
Zencoder::Account.create({:terms_of_service => 1,
                          :email => 'bob@example.com'})
Zencoder::Account.create({:terms_of_service => 1,
                          :email => 'bob@example.com',
                          :password => 'abcd1234',
                          :password_confirmation => 'abcd1234',
                          :affiliate_code => 'abcd1234'})
```

### details

```ruby
Zencoder::Account.details
Zencoder::Account.details(:api_key => 'abcd1234')
```

### integration

This will put your account into integration mode (site-wide).

```ruby
Zencoder::Account.integration
Zencoder::Account.integration(:api_key => 'abcd1234')
```

### live

This will put your account into live mode (site-wide).

```ruby
Zencoder::Account.live
Zencoder::Account.live(:api_key => 'abcd1234')
```

## Reports

### minutes

This will list the minutes used for your account within a certain, configurable range.

```ruby
Zencoder::Report.minutes(:from => "2011-10-30", :to => "2011-11-24")
```

### all

This will list all usage, including VOD and Live for your account within a certain, configurable range.

```ruby
Zencoder::Report.all(:from => "2011-10-30", :to => "2011-11-24")
```

### vod

This will list just VOD usage for your account within a certain, configurable range.

```ruby
Zencoder::Report.vod(:from => "2011-10-30", :to => "2011-11-24")
```

### live

This will list just Live usage for your account within a certain, configurable range.

```ruby
Zencoder::Report.live(:from => "2011-10-30", :to => "2011-11-24")
```

## Advanced HTTP

### Alternate HTTP Libraries

By default this library will use Net::HTTP to make all API calls. You can change the backend or add your own:

```ruby
require 'typhoeus'
Zencoder::HTTP.http_backend = Zencoder::HTTP::Typhoeus

require 'my_favorite_http_library'
Zencoder::HTTP.http_backend = MyFavoriteHTTPBackend
```

See the HTTP backends in this library to get started on your own.

### Advanced Options

A secondary options hash can be passed to any method call which will then be passed on to the HTTP backend. You can pass `timeout` (in milliseconds), `headers`, and `params` (will be added to the query string) to any of the backends. If you are using Typhoeus, see their documentation for further options. In the following example the timeout is set to one second:

```ruby
Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:timeout => 1000})
```


### SSL Verification

SSL verification using the default Net::HTTP backend requires that your ruby be appropriately configured with up to date path to a cert bundle on your system or by specifying the a CA file or CA path when sending requests.

```ruby
Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:ca_path => "/path/to/certs/"})
# or
Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:ca_file => "/path/to/certs/zen.crt"})
```

Alternatively you can add it to the default options.

```ruby
Zencoder::HTTP.default_options.merge!(:ca_path => "/path/to/certs/")
# or
Zencoder::HTTP.default_options.merge!(:ca_file => "/path/to/certs/zen.crt")
```

You can get a CA bundle from [the curl website](http://curl.haxx.se/docs/caextract.html), but it is recommended that you use your system's package manager to install these certs and keep them up to date.

However, if you'd like to skip SSL verification you can pass an option in the secondary options hash.

**NOTE: WE HIGHLY DISCOURAGE THIS! THIS WILL LEAVE YOU VULNERABLE TO MAN-IN-THE-MIDDLE ATTACKS!**

```ruby
Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:skip_ssl_verify => true})
```

Alternatively you can add it to the default options.

```ruby
Zencoder::HTTP.default_options.merge!(:skip_ssl_verify => true)
```

### Default Options

Default options are passed to the HTTP backend. These can be retrieved and modified.

```ruby
Zencoder::HTTP.default_options = {:timeout => 3000,
                                  :headers => {'Accept' => 'application/json',
                                               'Content-Type' => 'application/json'}}
```

## Advanced JSON

### Alternate JSON Libraries

This library uses the `multi_json` gem to encode and decode JSON. This fantastic gem lets you swap out the JSON backend at will and includes a working JSON encoder/decoder. You can check the [MultiJson](https://github.com/intridea/multi_json) project for more information on how to accomplish this.
