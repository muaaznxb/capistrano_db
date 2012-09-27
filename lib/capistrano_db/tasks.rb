require 'capistrano_db/util'
require 'capistrano_db/database'

Capistrano::Configuration.instance(:must_exist).load do |instance|

  Database = Capistrano::Db::Database
  Util = Capistrano::Db::Util

  instance.set :local_rails_env, ENV['RAILS_ENV'] || 'development' unless exists?(:local_rails_env)
  instance.set :rails_env, 'production' unless exists?(:rails_env)
  instance.set :stage, 'production' unless exists?(:stage)
  instance.set :db_local_clean, false unless exists?(:db_local_clean)

  namespace :db do
    desc 'Synchronize the local adapters to the remote adapters'
    task :push, :roles => :db do
      if Util.prompt 'Are you sure you want to REPLACE THE REMOTE DATABASE with local adapters'
        Database.local_to_remote(instance)
      end
    end

    desc 'Synchronize your local adapters using remote adapters data'
    task :pull, :roles => :db do
      if Util.prompt 'Are you sure you want to erase your local adapters with server adapters'
        Database.remote_to_local(instance)
      end
    end
  end
end