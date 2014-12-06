source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

# configuration - needs to be at the top!
gem 'dotenv-rails', '~> 0.11.1'
gem 'dotenv-deployment', '~> 0.0.2'

# Use postgresql as the database for Active Record
gem 'pg', '~>0.17.0'

gem 'equalizer'

# Use SCSS for style-sheets
gem 'sass-rails', '~> 4.0.3'
gem 'sprockets', '~>2.11.0' # bug-fix 3376e59
gem 'autoprefixer-rails'
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 4.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.1.0'

gem 'kaminari', '~> 0.16.1'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# font icon
gem 'font-awesome-rails'

# Search Gems
gem 'elasticsearch', '~> 1.0.5'
gem 'elasticsearch-model', '~> 0.1.5'
gem 'elasticsearch-rails', '~> 0.1.5'
# Create es test node
gem 'elasticsearch-extensions', group: :test

# Use unicorn as the app server
gem 'unicorn', '~> 4.8.0'

# corner banner on staging environment
gem 'rack-dev-mark', '~> 0.7.0'

gem 'seedbank'

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'brakeman', '~>2.6.0', require: false
  gem 'bullet', '~>4.14.0'
  gem 'rails_best_practices', '~>1.15.1'
  gem 'rubocop', '~> 0.27.0', require: false
  gem 'rubycritic', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'traceroute'
end

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.3.0'
  gem 'capistrano-bundler', '~> 1.1.3'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.0'
  gem 'capistrano-postgresql', '~> 2.0.0'
  gem 'capistrano-unicorn-nginx', github: 'BCS-io/capistrano-unicorn-nginx'
  gem 'capistrano-rails-collection', '~> 0.0.2'
  gem 'capistrano-db-tasks', require: false
  gem 'mascherano', '~> 1.1.0'
end

group :development, :test do
  gem 'capybara', '~> 2.4.0'
  gem 'capybara-webkit', '~>1.3.0'
  gem 'capybara-screenshot'
  gem 'capybara-slow_finder_errors'
  gem 'selenium-webdriver', '~>2.44.0'
  gem 'guard'
  gem 'guard-livereload'
  gem 'launchy', '~> 2.4.2'
  gem 'pry-rails', '~>0.3.2'
  gem 'rb-readline'
  gem 'pry-stack_explorer', '~>0.4.9.0'
  gem 'byebug', '~> 3.5.0'
  gem 'rack-mini-profiler', '~>0.9.0'
  gem 'rspec-rails', '~> 3.1.0'
end

group :test do
  gem 'coveralls', '~>0.7.0', require: false
  gem 'database_cleaner', '~> 1.3.0'
  gem 'timecop', '~>0.7.0'
end

group :test do
  gem 'rake', '~> 10.3.0'
end
