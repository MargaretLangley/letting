STDOUT.sync = true

desc "Imports lettings data from csv's generated by previous system."
task :patch_address2 do |_task, args|
  include Logging
  logger.info 'patch'
  if File.exist?('import_data/patch/address2_patch.csv')

    FileUtils.mkdir_p 'import_data/patched_legacy/'
    patched = address2_file.map! do |agent|
      matched = patch_file.detect do |patch_agent|
        agent[:human_ref] == patch_agent[:human_ref]
      end
      if matched
        matched
      else
        agent
      end
    end

    CSV.open('import_data/patched_legacy/patched_address2.csv',
             'w',
             write_headers: true, headers: DB::FileHeader.client) do |csv_object|
      patched.each do |row_array|
        csv_object << row_array
      end
    end
    logger.info 'complete'
  else
    warn missing_address2_csv_message
  end
end

def address2_file
  DB::FileImport.to_a 'address2',
                      headers: DB::FileHeader.agent,
                      location: 'import_data/legacy'
end

def patch_file
  DB::FileImport.to_a 'address2_patch',
                      headers: DB::FileHeader.agent_patch,
                      location: 'import_data/patch'
end

def missing_address2_csv_message
  'Warning: address2.csv is missing - a patch cannot be generated'
end

