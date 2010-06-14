# Zencoder

The gem for interacting with the API on [Zencoder](http://zencoder.com).

See [http://zencoder.com/docs/api](http://zencoder.com/docs/api) for more details on the API.

## Examples

### Getting Started

The first thing you'll need to interact with the Zencoder API is your API key. You can use your API key in one of two ways. The first, and in our opinion the best, is to set it and forget it on the Zencoder module like so:

    Zencoder.api_key = 'abcd1234'

Alternatively you can pass your API key in every request, but who wants to do that?

We'll include examples of both ways throughout this document.

#### Responses

All calls in the Zencoder library either raise Zencoder::HTTPError or return a Zencoder::Response.

A Zencoder::Response can be used as follows:

    response = Zencoder::Job.list
    response.success?     # => true if the response code was 200 through 299
    response.code         # => 200
    response.body         # => the JSON-parsed body or raw body if unparseable
    response.raw_body     # => the body pre-JSON-parsing
    response.raw_response # => the raw Net::HTTP or Typhoeus response (see below for how to use Typhoeus)

### Jobs

There's more you can do on jobs than anything else in the API. The following methods are available: `list`, `create`, `details`, `progress`, `resubmit`, `cancel`, `delete`.

#### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass two parameters to control the paging: `page` and `per_page`.

    Zencoder::Job.list
    Zencoder::Job.list(:per_page => 10)
    Zencoder::Job.list(:per_page => 10, :page => 2)
    Zencoder::Job.list(:per_page => 10, :page => 2, :api_key => 'abcd1234')

#### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Job creation API call on Zencoder](http://zencoder.com/docs/api/#encoding-job).

    Zencoder::Job.create({:input => 's3://bucket/key.mp4'})
    Zencoder::Job.create({:input => 's3://bucket/key.mp4',
                          :outputs => [{:label => 'vp8 for the web',
                                        :url => 's3://bucket/key_output.webm'}]})
    Zencoder::Job.create({:input => 's3://bucket/key.mp4', :api_key => 'abcd1234'})

#### details

The number passed to `details` is the ID of a Zencoder job.

    Zencoder::Job.details(1)
    Zencoder::Job.details(1, :api_key => 'abcd1234')

#### resubmit

The number passed to `resubmit` is the ID of a Zencoder job.

    Zencoder::Job.resubmit(1)
    Zencoder::Job.resubmit(1, :api_key => 'abcd1234')

#### cancel

The number passed to `cancel` is the ID of a Zencoder job.

    Zencoder::Job.cancel(1)
    Zencoder::Job.cancel(1, :api_key => 'abcd1234')

#### delete

The number passed to `delete` is the ID of a Zencoder job.

    Zencoder::Job.delete(1)
    Zencoder::Job.delete(1, :api_key => 'abcd1234')

### Outputs

#### progress

Please note that the number passed to `progress` is the output file ID.

    Zencoder::Output.progress(1)
    Zencoder::Output.progress(1, :api_key => 'abcd1234')

### Notifications

#### list

By default the jobs listing is paginated with 50 jobs per page and sorted by ID in descending order. You can pass three parameters to control the paging: `page`, `per_page`, and `since_id`. Passing `since_id` will return notifications for jobs created after the job with the given ID.

    Zencoder::Notification.list
    Zencoder::Notification.list(:per_page => 10)
    Zencoder::Notification.list(:per_page => 10, :page => 2)
    Zencoder::Notification.list(:per_page => 10, :page => 2, :since_id => 20)
    Zencoder::Notification.list(:api_key => 'abcd1234')

### Accounts

#### create

The hash you pass to the `create` method should be encodable to the [JSON you would pass to the Account creation API call on Zencoder](http://zencoder.com/docs/api/#accounts). No API key is required for this call, of course.

    Zencoder::Account.create({:terms_of_service => 1,
                              :email => 'bob@example.com'})
    Zencoder::Account.create({:terms_of_service => 1,
                              :email => 'bob@example.com',
                              :password => 'abcd1234',
                              :affiliate_code => 'abcd1234'})

#### details

    Zencoder::Account.details
    Zencoder::Account.details(:api_key => 'abcd1234')

#### integration

This will put your account into integration mode (site-wide).

    Zencoder::Account.integration
    Zencoder::Account.integration(:api_key => 'abcd1234')

#### live

This will put your account into live mode (site-wide).

    Zencoder::Account.live
    Zencoder::Account.live(:api_key => 'abcd1234')

### Advanced HTTP

#### Alternate HTTP Libraries

By default this library will use Net::HTTP to make all API calls. You can change the backend or add your own:

    require 'typhoeus'
    Zencoder::HTTP.http_class = Zencoder::HTTP::Typhoeus

    require 'my_favorite_http_class'
    Zencoder::HTTP.http_class = MyFavoriteHTTPClassWrapper

See the HTTP class wrappers in this library to get started on your own.

#### Advanced Options

A secondary options hash can be passed to any method call which will then be passed on to the HTTP backend. You can pass `timeout` (in milliseconds), `headers`, and `params` (will be added to the query string) to any of the backends. If you are using Typhoeus, see their documentation for further options.

    Zencoder::Job.list(:timeout => 1000) # Timeout is 1 second.

#### SSL

The Net::HTTP backend will do its best to locate your local SSL certs to allow SSL verification. For a list of paths that are checked, see `Zencoder::HTTP::NetHTTP.root\_cert\_paths`. Feel free to add your own at runtime.

    Zencoder::HTTP::NetHTTP.root\_cert\_paths << '/my/custom/cert/path'

### Advanced JSON

#### Alternate JSON Libraries

This library uses the `multi_json` gem to encode and decode JSON. It uses the `json_pure` gem by default for compatibility with different ruby implementations. You can change the JSON engine for MultiJson:

    MultiJson.engine = :yajl
