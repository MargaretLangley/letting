require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_agent'

# Without this you won't see standard output until finished running
STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import agent addresses data from CSV file'
    task :agents, [:range] => :environment do |_task, args|
      DB::ImportAgent.import patched_agent_file,
                             range: Rangify.from_str(args.range).to_i
    end

    def patched_agent_file
      DB::FileImport.to_a 'patched_address2',
                          headers: DB::FileHeader.agent,
                          location: 'import_data/patched_legacy'
    end
  end
end
