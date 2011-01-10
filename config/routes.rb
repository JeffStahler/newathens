ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'

  map.resources :avatars, :member => {:select => :post, :deselect => :post}
  map.resources :categories, :member => {:confirm_delete => :get}
  map.resources :forums, :member => {:confirm_delete => :get}
  map.resources :headers, :member => {:vote_up => :post, :vote_down => :post}
  map.resources :messages, :collection => {:more => :get}
  map.resources :posts, :member => {:quote => :get, :topic => :get}
  map.resources :ranks
  map.resources :topics, :member => {:show_new => :get}, :collection => {:mark_all_viewed => :get}
  map.resources :uploads
  map.resources :users, :member => {:admin => :post, :ban => :get, :remove_ban => :post, :confirm_delete => :get}, :has_many => [:articles, :posts]

  map.search 'search', :controller => 'search', :action => 'index'
  map.refresh_chatters 'refresh_chatters', :controller => 'messages', :action => 'refresh_chatters'

  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.register 'register', :controller => 'users', :action => 'new'

  map.chat 'chat', :controller => 'messages', :action => 'index'
  map.files 'files', :controller => 'uploads', :action => 'index'
  map.forum_root 'forum', :controller => 'forums', :action => 'index'

  map.catch_all '*path', :controller => 'topics', :action => 'unknown_request'
end