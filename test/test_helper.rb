ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/blueprints")
require 'test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all

  setup do
    Sham.reset
  end

  def login!(options = {})
    user = User.make(options)
    @request.session[:user_id] = user.id
    user
  end

  def logout!
    @request.session[:user_id] = nil
  end

  # TODO remove when all moved over to machinist
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
    @request.session[:online_at] = Time.now.utc
  end
end
