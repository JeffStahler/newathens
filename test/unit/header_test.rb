require 'test_helper'

class HeaderTest < ActiveSupport::TestCase
  
  test "make makes a valid record" do
    r = Header.make
    assert r.valid?
  end
  
  test "to_s returns attachment_file_name" do
    r = Header.make
    assert_equal r.attachment_file_name, r.to_s
  end
  
  test "to_param returns id-to_s" do
    r = Header.make
    assert_equal "#{r.id}-#{r.to_s.parameterize}", r.to_param
  end
  
  test "attachment_file_name is unique" do
    r1 = Header.make
    r2 = Header.create { |r| r.attachment_file_name = r1.attachment_file_name }
    assert r2.errors.on(:attachment_file_name)
  end
    
  test "belongs_to user" do
    u = User.make
    r = Header.make(:user => u)
    assert r.user, u
  end
  
  test "validates presence of user_id" do
    r = Header.create { |r| r.user = nil }
    assert r.errors.on(:user_id)
  end
  
  test "random with one header" do
    r1 = Header.make
    random = Header.random
    assert random == r1
  end
  
  test "random with two headers" do
    r1 = Header.make
    r2 = Header.make
    random = Header.random
    assert (random == r1) || (random == r2)
  end
  
  test "random with no headers" do
    Header.destroy_all 
    assert_nothing_raised do
      Header.random
    end
  end

  test "random with headers all with negative votes" do
    Header.destroy_all
    r1 = Header.make 
    r2 = Header.make
    r3 = Header.make 
    r1.vote_down
    r1.reload
    r2.vote_down
    r2.reload
    r3.vote_down    
    r3.reload
    assert_nothing_raised do
      Header.random
    end
  end

  test "random with one header with positive votes" do
    Header.destroy_all
    r1 = Header.make 
    r2 = Header.make
    r3 = Header.make 
    r1.vote_down
    r1.reload
    r2.vote_down
    r2.reload
    r3.vote_up    
    r3.reload
    assert_nothing_raised do
      random = Header.random
      assert r3 == random
    end
  end
  
  test "vote_up/vote_down" do
    r = Header.make
    assert_equal 0, r.votes
    r.vote_up
    r.reload
    assert_equal 1, r.votes
    r.vote_down
    r.reload
    assert_equal 0, r.votes
  end
end