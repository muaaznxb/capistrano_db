module Capistrano
  module Db
    module Database
      module Adapters
        module Postgres
          def credentials
            " -U#{@config['username']} " + (@config['host'] ? " -h#{@config['host']}" : '')
          end

          def dump_cmd
            (@config['password'] ? " PGPASSWORD='#{@config['password']}' " : '') + "pg_dump #{credentials} #{database}"
          end

          def import_cmd(file)
            (@config['password'] ? " PGPASSWORD='#{@config['password']}' " : '') + "psql #{credentials} #{database} < #{file}"
          end
        end
      end
    end
  end
end