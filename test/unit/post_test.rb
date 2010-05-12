require 'test_helper'

class PostTest < ActiveSupport::TestCase
  fixtures :all

  def test_page_value_set_properly
  end

  def test_to_s
    p = Post.find(1)
    assert_equal p.to_s, 'MyText'
  end

end
