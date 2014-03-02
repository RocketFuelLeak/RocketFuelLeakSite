set :whenever_command, "bundle exec whenever"
set :whenever_roles, [:app]
require "whenever/capistrano"

server "rocketfuelleak.com", :web, :app, :db, primary: true
set :port, 2553
set :rails_env, 'production'

namespace :deploy do
    task :refresh_sitemaps, roles: :app do
        #run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
        run_rake "sitemap:refresh"
    end

    after "deploy", "deploy:update_members"
end
