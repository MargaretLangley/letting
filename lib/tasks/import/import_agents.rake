require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/import_agent'

# Without this you won't see standard output until finished running
STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import agent addresses data from CSV file'
    task :agents, [:range] => :environment do |_task, args|
      DB::ImportAgent.import staging_agents,
                             range: Rangify.from_str(args.range).to_i
    end

    def staging_agents
      DB::CSVTransform.to_a 'staging_address2',
                            headers: DB::FileHeader.agent,
                            location: 'import_data/staging'
    end
  end
end
