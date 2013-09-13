namespace :import_data do

  desc "Uploads import data."
  task :upload, roles: :app do
    run "mkdir -p #{shared_path}/import_data"
    top.upload("import_data/", "#{shared_path}", { via: :scp, recursive: true } )
  end
  after "deploy:setup", "import_data:upload"

  desc "Symlink the import file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/import_data/ #{release_path}/import_data"
  end
  after "deploy:finalize_update", "import_data:symlink"

end