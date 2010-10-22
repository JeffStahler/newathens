RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  require 'yaml'
  CONFIG = (YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}).merge(ENV)
  CONFIG['s3'] = true if CONFIG['s3_access_id'] && CONFIG['s3_secret_key'] && CONFIG['s3_bucket_name']
  config.time_zone = 'UTC'
  config.i18n.default_locale = :en
  config.active_record.partial_updates = true
  config.frameworks -= [:active_resource]
  config.action_controller.session = {:key => CONFIG['session_key'], :secret => CONFIG['session_secret']}
  config.gem "paperclip"
  config.gem "right_aws"
  config.gem "right_http_connection"
  config.gem "searchlogic"
  config.gem "will_paginate", :version => '2.3.15'
  config.gem "hoptoad_notifier"
  config.gem "rack-no-www"
  require 'rack/no-www'
  config.middleware.use Rack::NoWWW
end
