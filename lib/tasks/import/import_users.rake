require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import users data from CSV file"
    task :users, [:test] => :environment do |task, args|
      puts missing_users_csv_message \
        unless File.exist?('import_data/new/users.csv')

      DB::ImportUser.import users_file
      load_test_users if args.test
    end

    private

    def users_file
      DB::FileImport.to_a 'users',
                          headers: DB::FileHeader.user,
                          location: 'import_data/new'
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

    def missing_users_csv_message
      "Warning: users.csv is missing - " \
      "only test users 'admin' and 'user' can be imported."
    end
  end
end
