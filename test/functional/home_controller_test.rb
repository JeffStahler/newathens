require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  def test_should_get_index_when_logged_in
    login_as :trevor
    get :index
    assert_response :success
  end

  def test_should_redirect_to_login_if_not_logged_in
    get :index
    assert_redirected_to login_path
  end
end