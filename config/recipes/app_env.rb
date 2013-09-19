# Configuration of the application.yml
# Used by figaro to set the ENV varaiables
#
namespace :app_env do
  desc "Copies the application.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    transfer :up, "config/application.yml", "#{shared_path}/config/application.yml"
  end
  after "deploy:setup", "app_env:setup"

  desc "Symlink the application.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "app_env:symlink"
end