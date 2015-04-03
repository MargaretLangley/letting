#
# Gemfile
#
# Keeping a Gemfile up to date and especially updated Gems with security issues
# is an important maintenance task.
#
# 1) Which Gems are out of date?
# 2) Update a Gem
# 3) Gemfile.lock
# 4) Versioning
# 5) Importance of a Gem to the Application
# 6) Resetting Gems back to the original version
# 7) Breaking Gem List
#
#
# 1) Which Gems are out of date?
#
# bundle outdated  or use https://gemnasium.com/BCS-io/letting
#
#
# 2) Update a Gem
#
#  Update a single Gem using bundle update < gem name >
#    - example of pg: bundle update gp
#
# If a gem has not changed check what restrictions the Gemfile specifies
# Taking pg as an example again. We can update to 0.18.1, 0.18.2, 0.18.3
# but not update to 0.19.1. To update to 0.19.1 you need to change the Gem
# statement in this file and then run bundle update as above.
#
# gem 'pg', '~>0.18.0'     =>      gem 'pg', '~>0.19.0'
#
# After updating a gem run rake though and if it passes before pushing up.
#
#
# 3) Gemfile.lock
#
# You should never change Gemfile.lock directly. By changing Gemfile and
# running bundle commands you change Gemfile.lock indirectly.
#
#
# 4) Versioning
#
# Most Gems follow Semantic Versioning:  http://semver.org/
#
# Risk of causing a problem:
# Low: 0.18.0 => 0.18.X        - bug fixes
# Low-Medium: 0.18.0 => 0.19.0 - New functionality but should not break old
#                                functionality.
# High:       0.18 = > 1.0.0   - Breaking changes with past code.
#
#
# 5) Importance of a Gem to the Application
#
# Gems which are within development will not affect the production application:
#
#  group :development do
#    gem 'better_errors', '~> 2.1.0'
#  end
#
# Gems without a block will affect the production application and you should be
# more careful with the update.
#
#
# 6) Resetting Gems back to the original version
#
# If you need to return your Gems to original version.
# a) git checkout .
# b) bundle install
#

#
# GEMS THAT BREAK THE BUILD
#
# A list of Gems that if updated will break the application.
#
# Gem                     Using      Last tested   Gem Bug
# byebug                  3.5.1            4.0.3         Y
# capistrano-db-tasks       0.3              0.4         Y
# jquery-ui-rails         4.1.2            5.0.3         N
# rake                   10.1.0           10.4.2         ?
#
#
source 'https://rubygems.org'
ruby '2.1.2'

#
# Production
#
gem 'dotenv-rails', '~> 1.0.0'  # needs to be at the top!

gem 'autoprefixer-rails', '~> 5.1.0'
gem 'bcrypt', '~> 3.1.9'
gem 'coffee-rails', '~> 4.1.0'
gem 'elasticsearch', '~> 1.0.0'
gem 'elasticsearch-model', '~> 0.1.6'
gem 'elasticsearch-rails', '~> 0.1.6'
gem 'equalizer'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.2.0'
gem 'jquery-rails', '~> 4.0.0'

# BREAKING GEM
# 5.0.3 - causes CapybaraHelper to fail
gem 'jquery-ui-rails', '4.1.2'

# Kaminari before elasticsearch
gem 'kaminari', '~> 0.16.0'
gem 'lograge'
gem 'pg', '~>0.18.0'
gem 'rails', '4.2.1'
gem 'rack-dev-mark', '~> 0.7.0'     # corner banner on staging environment
gem 'rails-env-favicon'

# BREAKING GEM
# rake versions after this break args options code in import rake (used for
# setting range and test user logins).
# TODO: fix for being able to read in args
# Using this version of the gem because it is the same as on production system
gem 'rake', '10.1.0'
gem 'sass-rails', '~> 5.0.1'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'seedbank'
gem 'sprockets', '~>2.12.3'
gem 'turbolinks', '~> 2.5.0'
gem 'uglifier', '~> 2.7.0'
gem 'unicorn', '~> 4.8.0'
gem 'whenever', require: false

#
# Capistrano deployment
#
group :development do
  gem 'airbrussh', require: false
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.3'

  #
  # Upgrading to 0.4.0 caused
  # createdb: database creation failed: ERROR:  permission denied to create
  gem 'capistrano-db-tasks', '0.3', require: false
  gem 'capistrano-postgresql', '~> 4.2.0'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.0'
  gem 'capistrano-rails-collection', '~> 0.0.3'
  gem 'capistrano-unicorn-nginx', github: 'BCS-io/capistrano-unicorn-nginx'
  gem 'mascherano', '~> 1.1.0'
end

#
# Development only
#
group :development do
  gem 'better_errors', '~> 2.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'brakeman', '~>3.0.0', require: false
  gem 'bullet', '~>4.14.0'
  gem 'rails_best_practices', '~>1.15.0'
  gem 'rubocop', '~> 0.29.0', require: false
  gem 'rubycritic', require: false
  gem 'scss-lint'
  gem 'traceroute'
end

#
# Development and testing
#
group :development, :test do
  #
  # BREAKING GEM
  # Throwing exceptions when it hits breakpoints
  #
  gem 'byebug', '3.5.1'
  gem 'capybara', '~> 2.4.0'

  gem 'capybara-webkit', '~> 1.4.1'
  gem 'capybara-screenshot'
  # 0.1.1 seems to introduce errors - Use this gem occasionally to weed out
  # performance errors with tests
  # gem 'capybara-slow_finder_errors', '0.1.0'
  gem 'meta_request'
  gem 'pry-rails', '~>0.3.0'
  gem 'pry-stack_explorer', '~>0.4.9.0'
  gem 'rack-mini-profiler', '~>0.9.0'
  gem 'rb-readline'
  gem 'rspec-rails', '~> 3.2.0'
  gem 'selenium-webdriver', '~>2.45.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'table_print'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'zonebie'
end

#
# Testing
#
group :test do
  gem 'coveralls', '~>0.7.0', require: false
  gem 'database_cleaner', '~> 1.4.0'

  # Create e.s. test node
  gem 'elasticsearch-extensions'
  gem 'timecop', '~>0.7.0'
end
