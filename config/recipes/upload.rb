namespace :import_data do

  desc "Uploads import data."
  task :upload, roles: :app do
    run "mkdir -p #{shared_path}/import_data"
    top.upload("import_data/", "#{shared_path}/import_data/", { via: :sftp } )
  end
  after "deploy:setup", "import_data:upload"

end