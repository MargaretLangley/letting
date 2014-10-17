require 'csv'

###
# Import Charged Ins
#
# Table that links the used combinations of cycles and charged_in
#
# Generated file from Postgres with he command:
# \copy (select distinct cycle_id, charged_in_id from charges order by
# cycle_id, charged_in_id) TO '~/cycle_charged_ins.csv'
# DELIMITER ',' CSV HEADER;
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/cycle_charged_ins.csv'

    desc 'Import cycle_charged_ins from CSV file'
    task :cycle_charged_ins do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          CycleChargedIn.create!(row.to_hash)
        end
      else
        warn "CycleChargedIn import: missing #{filename}"
        seed_cycle_charged_ins
      end
    end

    private

    def seed_cycle_charged_ins
      CycleChargedIn.create! [
        { id: 1, cycle_id: 1, charged_in_id: 1 },
        { id: 2, cycle_id: 1, charged_in_id: 2 },
        { id: 3, cycle_id: 2, charged_in_id: 1 },
      ]
    end
  end
end
