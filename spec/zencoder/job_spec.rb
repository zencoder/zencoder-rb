require "spec_helper"

RSpec.describe Zencoder::Job do
  before do
    @api_key = 'abc123'
  end

  describe ".create" do
    before do
      @url = "#{Zencoder.base_url}/jobs"
      @params = {:api_key => @api_key,
                 :input   => "s3://bucket-name/file-name.avi"}
      @params_as_json = Zencoder::Serializer.encode(@params)
    end

    it "POSTs to the correct url and return a response" do
      expect(Zencoder::HTTP).to receive(:post).with(@url, @params_as_json, {}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.create(@params).class
    end

    it "applies the global API key as a header" do
      Zencoder.api_key = 'asdfasdf'
      expect(Zencoder::HTTP).to receive(:post).
                                  with(instance_of(String),
                                       instance_of(String),
                                       headers: { "Zencoder-Api-Key" => Zencoder.api_key }).
                                  and_return(Zencoder::Response.new)
      Zencoder::Job.create(:input => @params[:input])
    end
  end

  describe ".list" do
    before do
      @url = "#{Zencoder.base_url}/jobs"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :page => 1,
                                                          :per_page => 50,
                                                          :state => nil},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key).class
    end

    it "merges params well" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => {:page => 1,
                                                         :per_page => 50,
                                                         :some => 'param',
                                                         :state => nil},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.list(:api_key => @api_key, :params => {:some => 'param'}).class
    end
  end

  describe ".details" do
    before do
      @job_id = 1
      @url = "#{Zencoder.base_url}/jobs/#{@job_id}"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.details(1, :api_key => @api_key).class
    end
  end

  describe ".progress" do
    before do
      @job_id = 1
      @url = "#{Zencoder.base_url}/jobs/#{@job_id}/progress"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, :headers => { "Zencoder-Api-Key" => @api_key }).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.progress(1, :api_key => @api_key).class
    end
  end

  describe ".resubmit" do
    before do
      @job_id = 1
      @url = "#{Zencoder.base_url}/jobs/#{@job_id}/resubmit"
    end

    it "PUTs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.resubmit(1, :api_key => @api_key).class
    end
  end

  describe ".cancel" do
    before do
      @job_id = 1
      @url = "#{Zencoder.base_url}/jobs/#{@job_id}/cancel"
    end

    it "PUTs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.cancel(1, :api_key => @api_key).class
    end
  end

  describe ".finish" do
    before do
      @job_id = 1
      @url = "#{Zencoder.base_url}/jobs/#{@job_id}/finish"
    end

    it "PUTs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:put).with(@url, nil, :headers => {"Zencoder-Api-Key" => @api_key}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Job.finish(1, :api_key => @api_key).class
    end
  end

end
