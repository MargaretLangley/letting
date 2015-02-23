# STAGING
#
# Capisrano environment settings
#
set :stage, :staging
set :branch, 'release_after_nigel_demonstration'

# Simple Role Syntax
role :app, %w(deployer@10.0.0.35)
role :web, %w(deployer@10.0.0.35)
role :db,  %w(deployer@10.0.0.35)

# bcs.io
server '10.0.0.35', user: 'deployer', roles: %w(web app db), primary: true

set :rails_env, :staging

set :nginx_server_name, 'letting-staging.local.bcs.io'
