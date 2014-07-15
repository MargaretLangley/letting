require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import users data from CSV file"
    task :users, [:test] => :environment do |task, args|
      if File.exist?('import_data/patch/users.csv')
        DB::ImportUser.import users_file
      else
        puts "Warning: users.csv is missing - " \
             "only test users 'admin' and 'user' can be imported."
      end
      load_test_users if args.test
    end

    def users_file
      DB::FileImport.to_a 'users',
                          headers: DB::FileHeader.user,
                          location: 'import_data/patch'
    end

    def load_test_users
      User.create! [
        {
          nickname: 'admin',
          email: 'admin@example.com',
          password: 'password',
          password_confirmation: 'password',
          admin: true
        },
        {
          nickname: 'user',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password',
          admin: false
        }
      ]
    end
  end
end
