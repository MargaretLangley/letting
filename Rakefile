# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will
# automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if %w(development test).include? Rails.env
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new

  task(:default).clear
  # HACK
  # scss_lint does not stop rake from continuing on error.
  # Added it to the start and end to maximize chance of seeing it.
  task default: [:scss_lint, :rubocop, 'spec:fast', 'spec:feature', :scss_lint]
  task test: ['spec:fast', 'spec:feature']
end
