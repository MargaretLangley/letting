require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import users data from CSV file"
    task :users, [:test] => :environment do |task, args|
      DB::ImportUser.import users_file
      if args.test
        User.create! [
          {
            email: 'admin@example.com',
            password: 'password',
            password_confirmation: 'password',
            admin: true
          },
          {
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password',
            admin: false
          }
        ]
      end
    end

    def users_file
      DB::FileImport.to_a 'users',
                          headers: DB::FileHeader.user,
                          location: 'import_data/patch'
    end
  end
end
