# config valid only for Capistrano 3.2.1
lock '3.2.1'

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
set :log_level, :info

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/github.yml config/twitter.yml config/google.yml config/devise.yml config/smtp.yml config/recaptcha.yml config/newrelic.yml config/wowapi.yml}

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
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "Setup the base config files"
  task :setup_configs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! "config/database.yml.example", "#{shared_path}/config/database.yml"
      upload! "config/secrets.yml.example", "#{shared_path}/config/secrets.yml"
      upload! "config/github.yml.example", "#{shared_path}/config/github.yml"
      upload! "config/twitter.yml.example", "#{shared_path}/config/twitter.yml"
      upload! "config/google.yml.example", "#{shared_path}/config/google.yml"
      upload! "config/devise.yml.example", "#{shared_path}/config/devise.yml"
      upload! "config/smtp.yml.example", "#{shared_path}/config/smtp.yml"
      upload! "config/recaptcha.yml.example", "#{shared_path}/config/recaptcha.yml"
      upload! "config/newrelic.yml.example", "#{shared_path}/config/newrelic.yml"
      upload! "config/wowapi.yml.example", "#{shared_path}/config/wowapi.yml"
      puts "Now edit the config files in #{shared_path}."
      puts "Execute the following commands:"
      puts "sudo ln -nfs #{current_path}/config/nginx_#{rails_env}.conf /etc/nginx/sites-enabled/#{application}_#{rails_env}"
      puts "sudo ln -nfs #{current_path}/config/unicorn_init_#{rails_env}.sh /etc/init.d/unicorn_#{application}_#{rails_env}"
      puts "sudo update-rc.d -f unicorn_#{application}_#{rails_env} defaults"
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

  after :deploy, :refresh_sitemaps do
    on roles(:app) do
      env_rake 'sitemap:refresh:no_ping'
    end
  end

  task :update_members do
    on roles(:app) do
      env_rake 'wow:update_members'
    end
  end

  task :update_rankings do
    on roles(:app) do
      env_rake 'wowprogress:update_rankings'
    end
  end
end

namespace :nginx do
  desc "Reload nginx configs"
  task :reload do
    on roles(:web) do
      sudo 'service nginx reload'
    end
  end

  desc "Restart nginx server"
  task :restart do
    on roles(:web) do
      execute :sudo, :service, :nginx, :restart
    end
  end
end

namespace :maintenance do
  desc "Start maintenance"
  task :start do
    on roles(:app) do
      env_rake 'maintenance:start'
    end
  end

  desc "End maintenance"
  task :end do
    on roles(:app) do
      env_rake 'maintenance:end'
    end
  end
end

def env_rake(*args)
  within release_path do
    with rails_env: fetch(:rails_env) do
      execute :rake, *args
    end
  end
end
