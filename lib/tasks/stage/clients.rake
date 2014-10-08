require_relative '../../stage/stage'

STDOUT.sync = true

namespace :db do
  namespace :stage do
    desc 'Improves legacy client data quality by patching inaccuracies.'
    task :clients do
      Stage.new(file_name: 'import_data/staging/staging_clients.csv',
                input: clients,
                instructions: [PatchRef.new(patch: patch_clients)]).stage
    end

    def clients
      DB::CSVTransform.new file_name: 'import_data/legacy/clients.csv',
                           headers: DB::FileHeader.client
    end

    def patch_clients
      DB::CSVTransform.new(file_name: 'import_data/patch/clients_patch.csv',
                           headers: DB::FileHeader.client).to_a
    end
  end
end
