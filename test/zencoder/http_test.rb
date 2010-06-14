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
