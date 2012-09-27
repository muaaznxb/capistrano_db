module Capistrano
  module Db
    module Database
      module Adapters
        module MySQL
          def credentials
            " -u #{@config['username']} " + (@config['password'] ? " -p\"#{@config['password']}\" " : '') + (@config['host'] ? " -h #{@config['host']}" : '')
          end

          def dump_cmd
            "mysqldump #{credentials} #{database}"
          end

          def import_cmd(file)
            "mysql #{credentials} -D #{database} < #{file}"
          end
        end
      end
    end
  end
end
