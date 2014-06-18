# Production
#
# Capisrano environment settings
#
set :stage, :staging
set :branch, 'master'

# Simple Role Syntax
role :app, %w{deployer@10.0.0.32}
role :web, %w{deployer@10.0.0.32}
role :db,  %w{deployer@10.0.0.32}

# bcs.io
server '10.0.0.32', user: 'deployer', roles: %w{web app db}, primary: true

set :rails_env, :staging

set :nginx_server_name, 'letting.local.bcs.io'