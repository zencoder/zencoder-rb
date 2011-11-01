# Zencoder

The gem for interacting with the API on [Zencoder](http://zencoder.com).

See [http://zencoder.com/docs/api](http://zencoder.com/docs/api) for more details on the API.

Tested on the following versions of Ruby:

* Ruby 1.8.6-p399
* Ruby 1.8.7-p174
* Ruby 1.9.1-p378
* Ruby 1.9.2-preview3
* Ruby Enterprise Edition 1.8.7-2010.02
* Rubinius 1.0.1-20100603
* jRuby 1.5.1

## Getting Started

The first thing you'll need to interact with the Zencoder API is your API key. You can use your API key in one of three ways. The first and easiest is to set it and forget it on the Zencoder module like so:

    Zencoder.api_key = 'abcd1234'

Alternatively, you can use an environment variable:

    ENV['ZENCODER_API_KEY'] = 'abcd1234'

You can also pass your API key in every request, but who wants to do that?

## Responses

All calls in the Zencoder library either raise Zencoder::HTTPError or return a Zencoder::Response.

A Zencoder::Response can be used as follows:

    response = Zencoder::Job.list
    response.success?     # => true if the response code was 200 through 299
    response.code         # => 200
    response.body         # => the JSON-parsed body or raw body if unparseable
    response.raw_body     # => the body pre-JSON-parsing
    response.raw_response # => the raw Net::HTTP or Typhoeus response (see below for how to use Typhoeus)

### Parameters

When sending API request parameters you can specify them as a non-string object, which we'll then serialize to JSON (by default):

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'})

Or you can specify them as a string, which we'll just pass along as the request body:

    Zencoder::Job.create('{"input": "s3://bucket/key.mp4"}')

## Jobs

There's more you can do on jobs than anything else in the API. The following methods are available: `list`, `create`, `details`, `progress`, `resubmit`, `cancel`, `delete`.

### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Job creation API call on Zencoder](http://zencoder.com/docs/api/#encoding-job). We'll auto-populate your API key if you've set it already.

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
    Zencoder::Job.create({:input => 's3://bucket/key.mp4',
                          :outputs => [{:label => 'vp8 for the web',
                                        :url => 's3://bucket/key_output.webm'}]})
    Zencoder::Job.create({:input => 's3://bucket/key.mp4', :api_key => 'abcd1234'})

This returns a Zencoder::Response object. The body includes a Job ID, and one or more Output IDs (one for every output file created).

    response = Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
    response.code           # => 201
    response.body['id']      # => 12345

### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass two parameters to control the paging: `page` and `per_page`.

    Zencoder::Job.list
    Zencoder::Job.list(:per_page => 10)
    Zencoder::Job.list(:per_page => 10, :page => 2)
    Zencoder::Job.list(:per_page => 10, :page => 2, :api_key => 'abcd1234')

### details

The number passed to `details` is the ID of a Zencoder job.

    Zencoder::Job.details(1)
    Zencoder::Job.details(1, :api_key => 'abcd1234')

### resubmit

The number passed to `resubmit` is the ID of a Zencoder job.

    Zencoder::Job.resubmit(1)
    Zencoder::Job.resubmit(1, :api_key => 'abcd1234')

### cancel

The number passed to `cancel` is the ID of a Zencoder job.

    Zencoder::Job.cancel(1)
    Zencoder::Job.cancel(1, :api_key => 'abcd1234')

### delete

The number passed to `delete` is the ID of a Zencoder job.

    Zencoder::Job.delete(1)
    Zencoder::Job.delete(1, :api_key => 'abcd1234')

## Outputs

### progress

*Important:* the number passed to `progress` is the output file ID, not the Job ID.

    Zencoder::Output.progress(1)
    Zencoder::Output.progress(1, :api_key => 'abcd1234')

## Notifications

### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass three parameters to control the paging: `page`, `per_page`, and `since_id`. Passing `since_id` will return notifications for jobs created after the job with the given ID.

    Zencoder::Notification.list
    Zencoder::Notification.list(:per_page => 10)
    Zencoder::Notification.list(:per_page => 10, :page => 2)
    Zencoder::Notification.list(:per_page => 10, :page => 2, :since_id => 20)
    Zencoder::Notification.list(:api_key => 'abcd1234')

## Accounts

### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Account creation API call on Zencoder](http://zencoder.com/docs/api/#accounts). No API key is required for this call, of course.

    Zencoder::Account.create({:terms_of_service => 1,
                              :email => 'bob@example.com'})
    Zencoder::Account.create({:terms_of_service => 1,
                              :email => 'bob@example.com',
                              :password => 'abcd1234',
                              :affiliate_code => 'abcd1234'})

### details

    Zencoder::Account.details
    Zencoder::Account.details(:api_key => 'abcd1234')

### integration

This will put your account into integration mode (site-wide).

    Zencoder::Account.integration
    Zencoder::Account.integration(:api_key => 'abcd1234')

### live

This will put your account into live mode (site-wide).

    Zencoder::Account.live
    Zencoder::Account.live(:api_key => 'abcd1234')

## Advanced HTTP

### Alternate HTTP Libraries

By default this library will use Net::HTTP to make all API calls. You can change the backend or add your own:

    require 'typhoeus'
    Zencoder::HTTP.http_backend = Zencoder::HTTP::Typhoeus

    require 'my_favorite_http_library'
    Zencoder::HTTP.http_backend = MyFavoriteHTTPBackend

See the HTTP backends in this library to get started on your own.

### Advanced Options

A secondary options hash can be passed to any method call which will then be passed on to the HTTP backend. You can pass `timeout` (in milliseconds), `headers`, and `params` (will be added to the query string) to any of the backends. If you are using Typhoeus, see their documentation for further options. In the following example the timeout is set to one second:

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:timeout => 1000})


### Format

By default we'll send and receive JSON for all our communication. If you would rather use XML then you can pass :format => :xml in the secondary options hash.

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:format => :xml})

### SSL Verification

We try to find the files necessary for SSL verification on your system, but sometimes this results in an error. If you'd like to skip SSL verification you can pass an option in the secondary options hash.

**NOTE: WE HIGHLY DISCOURAGE THIS! THIS WILL LEAVE YOU VULNERABLE TO MAN-IN-THE-MIDDLE ATTACKS!**

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'}, {:skip_ssl_verify => true})

Alternatively you can add it to the default options.

    Zencoder::HTTP.default_options.merge!(:skip_ssl_verify => true)

### Default Options

Default options are passed to the HTTP backend. These can be retrieved and modified.

    Zencoder::HTTP.default_options = {:timeout => 3000,
                                      :headers => {'Accept' => 'application/json',
                                                   'Content-Type' => 'application/json'}}

### SSL

The Net::HTTP backend will do its best to locate your local SSL certs to allow SSL verification. For a list of paths that are checked, see `Zencoder::HTTP::NetHTTP.root_cert_paths`. Feel free to add your own at runtime. Let us know if we're missing a common location.

    Zencoder::HTTP::NetHTTP.root_cert_paths << '/my/custom/cert/path'

If the ruby installed on your system is already aware of where your root cert path is and/or you would like us to NOT set it, you can do the following.

    Zencoder::HTTP::NetHTTP.skip_setting_root_cert_path = true

## Advanced JSON and XML

### Alternate JSON and XML Libraries

This library uses the `activesupport` gem to encode and decode JSON. The latest versions of ActiveSupport allow you to change the libraries used to decode JSON and XML.

You can change the JSON decoding backend for ActiveSupport in Rails 2.3 like so:

    ActiveSupport::JSON.backend = "JSONGem"

Or change the XML decoding backend for ActiveSupport in Rails 2.3 like so:

    ActiveSupport::XmlMini.backend = "Nokogiri"
