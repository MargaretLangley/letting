require 'csv'
require_relative '../../import/import'
require_relative '../../import/import_fields'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :import do

  desc "Import users data from CSV file"
  task users: :environment do
    DB::ImportUser.import DB::Import.csv_table('users', \
      headers: DB::ImportFields.user)
  end
end
