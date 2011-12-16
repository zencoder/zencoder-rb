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
        @params_as_json = Zencoder::Serializer.encode(@params, :json)
      end

      should "POST to the correct url and return a response" do
        Zencoder::HTTP.expects(:post).with(@url, @params_as_json, {}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.create(@params).class
      end

      should "apply the global API key when JSON and no api_key is passed" do
        Zencoder.api_key = 'asdfasdf'
        Zencoder::HTTP.expects(:post).with do |url, params, options|
          Zencoder::Serializer.decode(params)['api_key'] == Zencoder.api_key
        end.returns(Zencoder::Response.new)
        Zencoder::Job.create(:input => @params[:input])
        Zencoder.api_key = nil
      end

      should "apply the global API key when XML and no api_key is passed" do
        Zencoder.api_key = 'asdfasdf'
        Zencoder::HTTP.expects(:post).with do |url, params, options|
          Zencoder::Serializer.decode(params, :xml)['api_request']['api_key'] == Zencoder.api_key
        end.returns(Zencoder::Response.new)
        Zencoder::Job.create({:api_request => {:input => @params[:input]}}, {:format => :xml})
        Zencoder.api_key = nil
      end

      should "apply the global API key when an XML string is passed and no api_key is passed" do
        Zencoder.api_key = 'asdfasdf'
        Zencoder::HTTP.expects(:post).with do |url, params, options|
          Zencoder::Serializer.decode(params, :xml)['api_request']['api_key'] == Zencoder.api_key
        end.returns(Zencoder::Response.new)
        Zencoder::Job.create({:input => @params[:input]}.to_xml(:root => :api_request), {:format => :xml})
        Zencoder.api_key = nil
      end
    end

    context ".list" do
      setup do
        @url = "#{Zencoder.base_url}/jobs"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key,
                                                            :page => 1,
                                                            :per_page => 50,
                                                            :state => nil}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key).class
      end

      should "merge params well" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key,
                                                           :page => 1,
                                                           :per_page => 50,
                                                           :some => 'param',
                                                           :state => nil}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key, :params => {:some => 'param'}).class
      end
    end

    context ".details" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.details(1, :api_key => @api_key).class
      end
    end

    context ".resubmit" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/resubmit"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.resubmit(1, :api_key => @api_key).class
      end
    end

    context ".cancel" do
      setup do
        @job_id = 1
        @url = "#{Zencoder.base_url}/jobs/#{@job_id}/cancel"
      end

      should "GET the correct url and return a response" do
        Zencoder::HTTP.stubs(:put).with(@url, {:params => {:api_key => @api_key}}).returns(Zencoder::Response.new)
        assert_equal Zencoder::Response, Zencoder::Job.cancel(1, :api_key => @api_key).class
      end
    end

  end
end
