require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :import do

  desc "Import users data from CSV file"
  task users: :environment do
    DB::ImportUser.import DB::FileImport.to_a('users',
                                               headers: DB::FileHeader.user)
  end
end
