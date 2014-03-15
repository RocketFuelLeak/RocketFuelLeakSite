# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'RocketFuelLeakSite'
set :repo_url, 'git@github.com:RocketFuelLeak/RocketFuelLeakSite.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user, 'rails')}/apps/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/github.yml config/facebook.yml config/twitter.yml config/google.yml config/devise.yml config/smtp.yml config/recaptcha.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, { forward_agent: true }

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  before :deploy, :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  %w{start stop restart}.each do |command|
    desc "#{command} application"
    task command do
      on roles(:app), in: :sequence, wait: 5 do
        execute "/etc/init.d/unicorn_#{fetch(:application)}_#{fetch(:stage)}", command
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :refresh_sitemaps do
    on roles(:app) do
      within release_path do
        execute :rake, 'sitemap:refresh:no_ping'
      end
    end
  end

  after :deploy, :refresh_sitemaps

  task :update_members do
    on roles(:app) do
      within release_path do
        execute :rake, 'wow:update_members'
      end
    end
  end

  task :update_rankings do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'wowprogress:update_rankings'
        end
      end
    end
  end
end
