set :whenever_command, "bundle exec whenever"
set :whenever_roles, [:app]
require "whenever/capistrano"

server "rocketfuelleak.com", :web, :app, :db, primary: true
set :port, 2554
set :rails_env, 'production'
