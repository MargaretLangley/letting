require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_charge'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import clients data from CSV file"
    task :charges, [:range] => :environment do |task, args|
      range = Rangify.from_str(args.range).to_i
      DB::ImportCharge.import charges_file('acc_info'), range: range
      DB::ImportCharge.import patch_charges('acc_info_deleted'), range: range
    end

    def charges_file file_name
      DB::FileImport.to_a file_name,
                          headers: DB::FileHeader.charge,
                          location: 'import_data/legacy'
    end

    def patch_charges file_name
      DB::FileImport.to_a 'acc_info_deleted',
                          headers: DB::FileHeader.charge,
                          location: 'import_data/patch'
    end
  end
end




