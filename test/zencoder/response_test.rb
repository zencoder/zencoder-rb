require 'test_helper'

class Zencoder::ResponseTest < Test::Unit::TestCase

  context Zencoder::Response do

    context "#success?" do
      should "return true when code is between 200 and 299" do
        assert Zencoder::Response.new(:code => 200).success?
        assert Zencoder::Response.new(:code => 299).success?
        assert Zencoder::Response.new(:code => 250).success?
      end

      should "return false when code it less than 200 or greater than 299" do
        assert !Zencoder::Response.new(:code => 300).success?
        assert !Zencoder::Response.new(:code => 199).success?
      end
    end

    context "#errors" do
      should "return an empty array when body is not a Hash" do
        assert_equal [], Zencoder::Response.new(:body => 1).errors
        assert_equal [], Zencoder::Response.new(:body => "something").errors
        assert_equal [], Zencoder::Response.new(:body => [1]).errors
      end

      should "return the value of the key 'errors' as a compacted array when body is a Hash" do
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => ['must be awesome']}).errors
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => 'must be awesome'}).errors
        assert_same_elements ['must be awesome'], Zencoder::Response.new(:body => {'errors' => ['must be awesome', nil]}).errors
        assert_same_elements [], Zencoder::Response.new(:body => {}).errors
      end
    end

    context "#job_id" do
      should "return nil if body is not a Hash" do
        assert_nil Zencoder::Response.new(:body => 1).job_id
        assert_nil Zencoder::Response.new(:body => "something").job_id
        assert_nil Zencoder::Response.new(:body => [1]).job_id
      end

      should "return the value of the key 'id' if body is a Hash" do
        assert_equal 1, Zencoder::Response.new(:body => {'id' => 1}).job_id
        assert_equal "1", Zencoder::Response.new(:body => {'id' => "1"}).job_id
        assert_nil Zencoder::Response.new(:body => {}).job_id
      end
    end

    context "#output_ids" do
      should "return an empty array if body is not a Hash" do
        assert_equal [], Zencoder::Response.new(:body => 1).output_ids
        assert_equal [], Zencoder::Response.new(:body => "something").output_ids
        assert_equal [], Zencoder::Response.new(:body => [1]).output_ids
      end

      should "return an empty array when the 'outputs' key on body is not an Array" do
        assert_equal [], Zencoder::Response.new(:body => {'outputs' => 1}).output_ids
        assert_equal [], Zencoder::Response.new(:body => {'outputs' => "something"}).output_ids
      end

      should "return an empty array if any of the values of the 'outputs' array are not Hashes" do
        assert_equal [], Zencoder::Response.new(:body => {'outputs' => [{'id' => 1},1]}).output_ids
      end

      should "return all the output ids" do
        assert_same_elements [1,2,3], Zencoder::Response.new(:body => {'outputs' => [{'id' => 1},
                                                                                     {'id' => 2},
                                                                                     {'id' => 3}]}).output_ids
      end
    end

    context "#output_id" do
      should "return the first output_id in the response body" do
        assert_equal 1, Zencoder::Response.new(:body => {'outputs' => [{'id' => 1},
                                                                       {'id' => 2},
                                                                       {'id' => 3}]}).output_id
      end

      should "return nothing if the output_ids are not retrievable" do
        assert_nil Zencoder::Response.new(:body => {'outputs' => [{'id' => 1},1]}).output_id
      end
    end
  end

end
