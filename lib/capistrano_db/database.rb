require 'capistrano_db/adapters/mysql'
require 'capistrano_db/adapters/postgresql'

module Capistrano
  module Db
    module Database

      class Base
        attr_accessor :config, :output_file

        def initialize(cap_instance)
          @cap = cap_instance
        end

        def credentials
          raise Implementation 'You have to implement credentials into your adapter.'
        end

        def adapter
          @config['adapter']
        end

        def database
          @config['database']
        end

        def output_file
          @output_file ||= "db/dump_#{database}.sql.bz2"
        end

        private
        def dump_cmd
          raise Implementation 'You have to implement dump_cmd into your adapter.'
        end

        def import_cmd(file)
          raise Implementation 'You have to implement import_cmd into your adapter.'
        end
      end

      class Remote < Base
        def initialize(cap_instance)
          super(cap_instance)
          @cap.run("cat #{@cap.current_path}/config/database.yml") { |c, s, d| @config = YAML.load(d)[(@cap.rails_env || 'production').to_s] }
        end

        def dump
          @cap.run "cd #{@cap.current_path}; #{dump_cmd} | bzip2 - - > #{output_file}"
          self
        end

        def download(local_file = "#{output_file}")
          remote_file = "#{@cap.current_path}/#{output_file}"
          @cap.get remote_file, local_file
        end

        # cleanup = true removes the mysqldump file after loading, false leaves it in db/
        def load(file, cleanup)
          unzip_file = File.join(File.dirname(file), File.basename(file, '.bz2'))
          @cap.run "cd #{@cap.current_path}; bunzip2 -f #{file} && RAILS_ENV=#{@cap.rails_env} rake db:drop db:create --trace && #{import_cmd(unzip_file)}"
          File.unlink(unzip_file) if cleanup
        end
      end

      class Local < Base
        def initialize(cap_instance)
          super(cap_instance)
          @config = YAML.load_file(File.join('config', 'database.yml'))[@cap.local_rails_env]
        end

        # cleanup = true removes the mysqldump file after loading, false leaves it in db/
        def load(file, cleanup)
          unzip_file = File.join(File.dirname(file), File.basename(file, '.bz2'))
          system("bunzip2 -f #{file} && rake db:drop db:create --trace && #{import_cmd(unzip_file)} && rake db:migrate")
          File.unlink(unzip_file) if cleanup
        end

        def dump
          system "#{dump_cmd} | bzip2 - - > #{output_file}"
          self
        end

        def upload
          remote_file = "#{@cap.current_path}/#{output_file}"
          @cap.upload output_file, remote_file
        end
      end

      class << self
        attr_accessor :local_db, :remote_db

        def check
          if @local_db.adapter != @remote_db.adapter
            raise "Remote and local database adapters must be match. We found Local:#{@local_db.adapter} and Remote:#{@remote_db.adapter}"
          end

          unless @local_db.adapter == 'mysql' or @local_db.adapter == 'mysql2' or @local_db.adapter == 'postgresql'
            raise 'Only mysql, mysql2 and postgresql adapters on remote and local server is supported'
          end
        end

        def remote_to_local(instance)
          @local_db = Local.new(instance)
          @remote_db = Remote.new(instance)

          check
          set_adapters

          @remote_db.dump.download
          @local_db.load(@remote_db.output_file, instance.fetch(:db_local_clean))
        end

        def local_to_remote(instance)
          @local_db = Local.new(instance)
          @remote_db = Remote.new(instance)

          check
          set_adapters

          @local_db.dump.upload
          @remote_db.load(@local_db.output_file, instance.fetch(:db_local_clean))
        end

        def set_adapters
          if @local_db.adapter == 'mysql' or @local_db.adapter == 'mysql2'
            class << @local_db
              include Adapters::MySQL
            end
            class << @remote_db
              include Adapters::MySQL
            end
          elsif @local_db.adapter == 'postgresql'
            class << @local_db
              include Adapters::Postgres
            end
            class << @remote_db
              include Adapters::Postgres
            end
          end
        end
      end
    end
  end
end