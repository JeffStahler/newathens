class HomeController < ApplicationController
  def index
    @message = Message.last
    @chatters = User.chatting
    @topics = Topic.get(params[:page])
    render :template => 'topics/index'
  end

  def help
  end
end