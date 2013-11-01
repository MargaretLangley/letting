require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_client'

STDOUT.sync = true

namespace :import do

  desc "Import clients data from CSV file"
  task clients: :environment do
    DB::ImportClient.import clients_file,
                            DB::Patch.import(Client, patch_file)
  end


  def clients_file
    DB::FileImport.to_a 'clients',
                        headers: DB::FileHeader.client
  end

  def patch_file
    DB::FileImport.to_a 'clients_patch',
                        headers: DB::FileHeader.client,
                        location: 'import_data/patch'
  end
end


