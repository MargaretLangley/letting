#  Change
#  Avoid app names with - a pain with postgres
#  capify . and allow asset pipeline
#  :server_name
#  :application
#  unicorn in gemfile
require 'bundler/capistrano'

set :ruby_version,  "2.0"
set :bundle_cmd,    "chruby-exec #{ruby_version} -- bundle"

# set :whenever_command, "bundle exec whenever"
# require 'whenever/capistrano'

load 'config/recipes/base'
load 'config/recipes/app_env'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
load 'config/recipes/postgresql'
load 'config/recipes/seed'
load 'config/recipes/check'
load 'config/recipes/monit'
load 'config/recipes/upload'

namespace :rake do
  desc 'Run a task on a remote server.'
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

set  :host, '193.183.99.251'
server "#{host}", :web, :app, :db, primary: true
set :server_name, 'letting.bcs.io'  # change

set :user, 'deployer'
set :application, 'letting'  # change
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository_owner, 'BCS-io' # change
set :repository, "git@github.com:#{repository_owner}/#{application}.git"
set :branch, 'master'
set :keep_releases, 3

set :maintenance_template_path,
    File.expand_path('../recipes/templates/maintenance.html.erb', __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_rivate_key")]

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases
