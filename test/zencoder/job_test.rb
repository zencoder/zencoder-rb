require 'test_helper'

class Zencoder::JobTest < Test::Unit::TestCase

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

  context "An initialized job" do
    setup do
      @job = Zencoder::Job.new({:api_key => 'abcd1234',
                                :input   => "s3://bucket-name/file-name.avi"})
    end

    should "return a response when calling #create" do
      assert_equal Zencoder::Response, @job.create.class
    end

    should "return a successful response when #create succeeds" do
      assert @job.create.success?
    end

    should "return a failed response when #create fails" do
      assert !@job.create.success?
    end

    should "return a hash of errors when failed to create" do
      
    end
  end

end
