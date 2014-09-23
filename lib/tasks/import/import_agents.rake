require 'csv'
require_relative '../../import/file_import'
require_relative '../../import/file_header'
require_relative '../../import/import_agent'

# Without this you won't see stdoutput until finished running
STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import agent addresses data from CSV file'
    task :agents, [:range] => :environment do |_task, args|
      DB::ImportAgent.import agent_file,
                             range: Rangify.from_str(args.range).to_i,
                             patch: DB::Patch.import(AgentWithId,
                                                     patch_file)
    end

    def agent_file
      DB::FileImport.to_a 'address2',
                          headers: DB::FileHeader.agent,
                          location: 'import_data/legacy'
    end

    def patch_file
      DB::FileImport.to_a 'address2_patch',
                          headers: DB::FileHeader.agent_patch,
                          location: 'import_data/patch'
    end
  end
end
