require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/charges/import_charge'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import clients data from CSV file'
    task :charges, [:range] => :environment do |_task, args|
      range = Rangify.from_str(args.range).to_i
      DB::ImportCharge.import staging_charges, range: range
      DB::ImportCharge.import patch_charges, range: range
    end

    def staging_charges
      DB::FileImport.to_a 'staging_acc_info',
                          headers: DB::FileHeader.charge,
                          location: 'import_data/staging'
    end

    def patch_charges
      DB::FileImport.to_a 'acc_info_deleted',
                          headers: DB::FileHeader.charge,
                          location: 'import_data/patch'
    end
  end
end
