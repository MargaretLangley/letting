source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use postgresql as the database for Active Record
gem 'pg', '~>0.17.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem "autoprefixer-rails"
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'kaminari', '~> 0.15.1'

# Configuration of sensitive information
gem 'figaro', '~> 0.7.0'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '2.15.4'
  gem 'capistrano-rbenv'
end

# Use debugger
# gem 'debugger', group: [:development, :test]


 group :development, :test do
   gem 'rspec-rails', '~> 2.14.0'
   gem 'capybara', '~> 2.2.0'
   gem "capybara-webkit", '~>1.1.0'
   gem 'guard'
   gem 'guard-rspec', '~> 3.0.2'
   gem 'guard-livereload'
   gem 'launchy', '~> 2.4.2'
end


group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'bullet'
  gem 'rack-mini-profiler'
end

group :development do
  gem 'brakeman', require: false
  gem "rails_best_practices"
end

group :test do
  gem 'zeus'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.0.1'
  gem 'timecop'
end

group :test do
  gem 'rake', '0.9.6'
end
