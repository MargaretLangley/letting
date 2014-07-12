lock '3.2.1'

#
# Application variables
#
set :application, 'letting'
set :user, 'deployer'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:full_app_name)}"

# SCM
set :scm, :git
set :repo_url, 'git@bitbucket.org:bcsltd/letting.git'
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"]

# rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.1.2'
set :rbenv_custom_path, '/opt/rbenv'

set :unicorn_workers, 2

set :tests, ["spec"]

# house keeping
set :keep_releases, 3

#
# db-tasks (and assets)
# sgruhier/capistrano-db-tasks
#

# if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/assets public/att)
set :local_assets_dir, %w(public/assets public/att)
