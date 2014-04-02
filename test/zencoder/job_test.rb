require 'test_helper'

class Zencoder::JobTest < Test::Unit::TestCase

  context Zencoder::Job do
    setup do
      @api_key = 'abc123'
    end

    context ".create" do
      setup do
        @url = "#{Zencoder.base_url}/jobs"
        @params = {:api_key => @api_key,
                   :input   => "s3://bucket-name/file-name.avi"}
        @params_as_json = Zencoder::Serializer.encode(@params)
      end

      should "POST to the correct url and return a response" do
        Zencoder::HTTP.expects(:post).with(@url, @params_as_json, {}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.create(@params).class
      end

      should "apply the global API key as a header" do
        Zencoder.api_key = 'asdfasdf'
        Zencoder::HTTP.expects(:post).with do |url, params, options|
          options[:headers]["Zencoder-Api-Key"] == Zencoder.api_key
        end.returns(Zencoder::Response.new)
        Zencoder::Job.create(:input => @params[:input])
        Zencoder.api_key = nil
      end
    end

    context ".list" do
      setup do
        @url = "#{Zencoder.base_url}/jobs"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => { :page => 1,
                                                            :per_page => 50,
                                                            :state => nil},
                                               :headers => { "Zencoder-Api-Key" => @api_key }}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key).class
      end

      should "merge params well" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:page => 1,
                                                           :per_page => 50,
                                                           :some => 'param',
                                                           :state => nil},
                                               :headers => { "Zencoder-Api-Key" => @api_key }}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key, :params => {:some => 'param'}).class
      end
    end

    context ".details" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.details(1, :api_key => @api_key).class
      end
    end

    context ".progress" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/progress"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.progress(1, :api_key => @api_key).class
      end
    end

    context ".resubmit" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/resubmit"
      end

      should "PUT the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.resubmit(1, :api_key => @api_key).class
      end
    end

    context ".cancel" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/cancel"
      end

      should "PUT the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.cancel(1, :api_key => @api_key).class
      end
    end

    context ".finish" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/finish"
      end

      should "PUT the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.finish(1, :api_key => @api_key).class
      end
    end

  end
end
