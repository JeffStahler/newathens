require(File.join(File.dirname(__FILE__), 'config', 'boot'))
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'
require "heroku_backup_task"

task :cron do
  HerokuBackupTask.execute
end
