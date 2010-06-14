require 'test_helper'

class Zencoder::JobTest < Test::Unit::TestCase

  context Zencoder::Job do
    should "be initializable with a hash" do
      assert_nothing_raised do
        Zencoder::Job.new({})
      end
    end

    should "be initializable with nothing" do
      assert_nothing_raised do
        Zencoder::Job.new
      end
    end

    should "not initialize when passed something other than a hash" do
      assert_raises Zencoder::ArgumentError do
        Zencoder::Job.new(1)
      end
    end

    context "when initialized" do
      setup do
        @url = 'https://app.zencoder.com/api/jobs'
        @params = {:api_key => 'abcd1234',
                   :input   => "s3://bucket-name/file-name.avi"}
        @job = Zencoder::Job.new(@params)
      end

      should "return a response when calling #create" do
        assert_equal Zencoder::Response, @job.create.class
      end

      should "return a successful response when #create succeeds" do
        Zencoder::HTTPS.stubs(:post).with(@url, @params.to_json, {}).returns(Zencoder::Response.new(:code => 201))
        assert @job.create.success?
      end

      should "return a failed response when #create fails" do
        Zencoder::HTTPS.stubs(:post).with(@url, @params.to_json, {}).returns(Zencoder::Response.new(:code => 422))
        assert !@job.create.success?
      end
    end

    context ".create" do
      setup do
        @url = 'https://app.zencoder.com/api/jobs'
        @params = {:api_key => 'abcd1234',
                   :input   => "s3://bucket-name/file-name.avi"}
      end

      should "return a response" do
        assert_equal Zencoder::Response, Zencoder::Job.create.class
      end

      should "return a successful response when #create succeeds" do
        Zencoder::HTTPS.stubs(:post).with(@url, @params.to_json, {}).returns(Zencoder::Response.new(:code => 201))
        assert Zencoder::Job.create(@params).success?
      end

      should "return a failed response when #create fails" do
        Zencoder::HTTPS.stubs(:post).with(@url, @params.to_json, {}).returns(Zencoder::Response.new(:code => 422))
        assert !Zencoder::Job.create(@params).success?
      end
    end
  end
end
