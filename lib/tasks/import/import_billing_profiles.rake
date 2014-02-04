require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_billing_profile'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :db do
  namespace :import do

    desc "Import billing profile addresses data from CSV file"
    task :billing_profiles, [:range] => :environment do |task, args|
      DB::ImportBillingProfile.import billing_file,
                                      range: Rangify.from_str(args.range).to_i,
                                      patch: DB::Patch.import(BillingProfileWithId,
                                                       patch_file)
     end

     def billing_file
       DB::FileImport.to_a 'address2',
                            headers: DB::FileHeader.billing_profile,
                            location: 'import_data/latest'
     end

     def patch_file
       DB::FileImport.to_a 'address2_patch',
                           headers: DB::FileHeader.billing_profile,
                           location: 'import_data/patch'
     end
  end
end
