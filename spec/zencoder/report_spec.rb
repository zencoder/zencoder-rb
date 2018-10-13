require "spec_helper"

RSpec.describe Zencoder::Report do

  describe ".minutes" do
    before do
      @api_key = "abcd123"
      @url = "#{Zencoder.base_url}/reports/minutes"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01",
                                                          :grouping => "foo"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.minutes(:api_key => @api_key, :from => "2011-01-01",
                                                                                      :to => "2011-06-01",
                                                                                      :grouping => "foo").class
    end

    it "merges params well" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.minutes(:api_key => @api_key, :from => "2011-01-01", :to => "2011-06-01").class
    end
  end

  describe ".all" do
    before do
      @api_key = "abcd123"
      @url = "#{Zencoder.base_url}/reports/all"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01",
                                                          :grouping => "foo"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.all(:api_key => @api_key, :from => "2011-01-01",
                                                                                      :to => "2011-06-01",
                                                                                      :grouping => "foo").class
    end

    it "merges params well" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.all(:api_key => @api_key, :from => "2011-01-01", :to => "2011-06-01").class
    end
  end

  describe ".vod" do
    before do
      @api_key = "abcd123"
      @url = "#{Zencoder.base_url}/reports/vod"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01",
                                                          :grouping => "foo"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.vod(:api_key => @api_key, :from => "2011-01-01",
                                                                                      :to => "2011-06-01",
                                                                                      :grouping => "foo").class
    end

    it "merges params well" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.vod(:api_key => @api_key, :from => "2011-01-01", :to => "2011-06-01").class
    end
  end

  describe ".live" do
    before do
      @api_key = "abcd123"
      @url = "#{Zencoder.base_url}/reports/live"
    end

    it "GETs the correct url and return a response" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01",
                                                          :grouping => "foo"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.live(:api_key => @api_key, :from => "2011-01-01",
                                                                                      :to => "2011-06-01",
                                                                                      :grouping => "foo").class
    end

    it "merges params well" do
      allow(Zencoder::HTTP).to receive(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).and_return(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.live(:api_key => @api_key, :from => "2011-01-01", :to => "2011-06-01").class
    end
  end

end
