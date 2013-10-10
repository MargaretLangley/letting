require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/import_fields'
require_relative '../../import/import_client'

STDOUT.sync = true

namespace :import do

  desc "Import clients data from CSV file"
  task clients: :environment do
    DB::ImportClient.import DB::FileImport.to_a('clients',
      headers: DB::ImportFields.client),
        DB::Patch.import(Client, DB::FileImport.to_a('clients_patch',
          headers: DB::ImportFields.client, location: 'import_data/patch'))
  end
end


