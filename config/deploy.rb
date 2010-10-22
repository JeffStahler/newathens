load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :repository, 'git://github.com/trevorturk/newathens.git'
set :scm, :git
set :branch, 'master'
set :deploy_via, :copy
set :git_shallow_clone, 1
set :keep_releases, 5

set :application, 'newathens'
set :deploy_to, '/var/www/newathens'
set :location, 'newathens.org'

set :user, 'newathens'
ssh_options[:port] = 222

role :app, location
role :web, location
role :db, location, :primary => true

after 'deploy:update_code', 'deploy:upload_config_files'
# after 'deploy:update_code', 'deploy:cleanup'
# after 'deploy:update_code', 'deploy:create_symlinks'
after 'deploy:update_code', 'deploy:set_permissions'
# after   'deploy:update_code', 'deploy:bundler'
before 'deploy:migrate', 'deploy:web:disable'
after 'deploy:migrate', 'deploy:web:enable'

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :migrate, :roles => :app do
    run "cd #{release_path} && /opt/ruby-enterprise/bin/rake RAILS_ENV=production db:migrate"
  end
  task :bundler do
    run "cd #{release_path} && /opt/ruby-enterprise/bin/bundle install vendor/bundler_gems"
  end
  task :set_permissions do
    run "/bin/chown -R newathens:newathens #{release_path}/*"
  end
  task :upload_config_files do
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :create_symlinks do
    require 'yaml'
    download "#{release_path}/config/symlinks.yml", "/tmp/eldorado_symlinks.yml"
    YAML.load_file('/tmp/eldorado_symlinks.yml').each do |share|
      run "rm -rf #{release_path}/public/#{share}"
      run "mkdir -p #{shared_path}/system/#{share}"
      run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
    end
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
