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

  test "test_randomness" do
    #use pearsons chi square statistical test to confirm that headers 
    #are close to what you would expect theoretically.
    #this test can fail by random chance even if the algorithm is working
    # however this should only happen once every 254,716,573 tests
    # therefore, if this test fails, there is probably something wrong
    # with the random header code.

    total_votes = 0
    eligibleheaders = 0
    test_headers = Array.new
    header_selected_counts = Array.new
    
    (0..19).each do |i| 
      header_selected_counts[i] = 0
      test_headers[i] = Header.make
      test_headers[i].description = i.to_s
      (rand(20)).times do
      	test_headers[i].vote_up
        test_headers[i].reload
        total_votes += 1
      end  
      if test_headers[i].votes != 0
        eligibleheaders +=1
      end

    end

    x = 0
    (1000).times do
      x += 1
      random = Header.random
      header_selected_counts[random.description.to_i] += 1
    end
    theoretical_header_count = Array.new
    chi_squared_statistic = 0
    (0..19).each do |i|

    if  test_headers[i].votes != 0
      if i <= 4
        theoretical_header_count[i] = (1000.to_f)*((1/3.to_f)*((1/5.to_f) + (1/eligibleheaders.to_f)+(test_headers[i].votes/total_votes.to_f)))
      else
        theoretical_header_count[i] = (1000.to_f)*((1/3.to_f)*((1/eligibleheaders.to_f)+(test_headers[i].votes/total_votes.to_f)))
      end
    end 

    if test_headers[i].votes != 0
      chi_squared_statistic += (((header_selected_counts[i] - theoretical_header_count[i]) ** 2)/theoretical_header_count[i])
    end
  end

 
  assert chi_squared_statistic < 80 
  end




end