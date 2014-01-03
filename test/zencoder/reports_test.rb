require 'test_helper'

class Zencoder::ReportTest < Test::Unit::TestCase

  context ".minutes" do
    setup do
      @api_key = "abcd123"
      @url = "#{Zencoder.base_url}/reports/minutes"
    end

    should "GET the correct url and return a response" do
      Zencoder::HTTP.stubs(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01",
                                                          :grouping => "foo"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).returns(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.minutes(:api_key => @api_key, :from => "2011-01-01",
                                                                                      :to => "2011-06-01",
                                                                                      :grouping => "foo").class
    end

    should "merge params well" do
      Zencoder::HTTP.stubs(:get).with(@url, {:params => { :from => "2011-01-01",
                                                          :to => "2011-06-01"},
                                             :headers => { "Zencoder-Api-Key" => @api_key }}).returns(Zencoder::Response.new)
      assert_equal Zencoder::Response, Zencoder::Report.minutes(:api_key => @api_key, :from => "2011-01-01", :to => "2011-06-01").class
    end
  end

end
