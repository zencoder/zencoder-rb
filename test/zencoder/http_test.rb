require 'test_helper'

class Zencoder::HTTPTest < Test::Unit::TestCase

  context Zencoder::HTTP do
    should "have a default_options hash" do
      assert Zencoder::HTTP.default_options.is_a?(Hash)
    end

    should "have a default HTTP backend" do
      assert Zencoder::HTTP.http_backend
    end

    should "allow the changing of the HTTP backend" do
      assert_not_equal Zencoder::HTTP.http_backend, Zencoder::HTTP::Typhoeus

      assert_nothing_raised do
        Zencoder::HTTP.http_backend = Zencoder::HTTP::Typhoeus
      end

      assert_equal Zencoder::HTTP.http_backend, Zencoder::HTTP::Typhoeus
    end

    should "raise a Zencoder::HTTPError when there is an HTTP error" do
      Zencoder::HTTP.http_backend.expects(:get).
                                  with('https://example.com', Zencoder::HTTP.default_options).
                                  raises(Errno::ECONNREFUSED)

      assert_raises Zencoder::HTTPError do
        Zencoder::HTTP.get('https://example.com')
      end
    end

    should "return a Zencoder::Response" do
      Zencoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      Zencoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      Zencoder::HTTP.http_backend.stubs(:get).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      Zencoder::HTTP.http_backend.stubs(:delete).returns(stub(:code => 200, :body => '{"some": "hash"}'))

      assert Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').is_a?(Zencoder::Response)
      assert Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').is_a?(Zencoder::Response)
      assert Zencoder::HTTP.get('https://example.com').is_a?(Zencoder::Response)
      assert Zencoder::HTTP.delete('https://example.com').is_a?(Zencoder::Response)
    end

    should "store the raw response" do
      post_stub = stub(:code => 200, :body => '{"some": "hash"}')
      Zencoder::HTTP.http_backend.stubs(:post).returns(post_stub)
      assert_equal post_stub, Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_response
    end

    should "store the raw response body" do
      Zencoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      assert_equal '{"some": "hash"}', Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_body
    end

    should "store the response code" do
      Zencoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      assert_equal 200, Zencoder::HTTP.post('https://example.com', '{"some": "hash"}').code
    end

    should "JSON parse the response body" do
      Zencoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": "hash"}'))
      assert_equal({'some' => 'hash'}, Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').body)
    end

    should "store the raw body if the body fails to be JSON parsed" do
      Zencoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": bad json'))
      assert_equal '{"some": bad json', Zencoder::HTTP.put('https://example.com', '{"some": "hash"}').body
    end

    context ".post" do
      should "call post on the http_backend" do
        Zencoder::HTTP.http_backend.expects(:post).
                                    with('https://example.com', Zencoder::HTTP.default_options.merge(:body => '{}')).
                                    returns(Zencoder::Response.new)

        Zencoder::HTTP.post('https://example.com', '{}')
      end
    end

    context ".put" do
      should "call put on the http_backend" do
        Zencoder::HTTP.http_backend.expects(:put).
                                    with('https://example.com', Zencoder::HTTP.default_options.merge(:body => '{}')).
                                    returns(Zencoder::Response.new)

        Zencoder::HTTP.put('https://example.com', '{}')
      end
    end

    context ".get" do
      should "call post on the http_backend" do
        Zencoder::HTTP.http_backend.expects(:get).
                                    with('https://example.com', Zencoder::HTTP.default_options).
                                    returns(Zencoder::Response.new)

        Zencoder::HTTP.get('https://example.com')
      end
    end

    context ".delete" do
      should "call post on the http_backend" do
        Zencoder::HTTP.http_backend.expects(:delete).
                                    with('https://example.com', Zencoder::HTTP.default_options).
                                    returns(Zencoder::Response.new)

        Zencoder::HTTP.delete('https://example.com')
      end
    end
  end

end
