require "bundler/capistrano"
require "rvm/capistrano"

set :whenever_command, "bundle exec whenever"
set :whenever_roles, [:app]
require "whenever/capistrano"

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "RocketFuelLeakSite"
set :user, "rails"
set :port, 2553
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, :git
set :repository,  "git@github.com:RocketFuelLeak/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

task :uname do
    run "uname -a"
end

after "deploy", "deploy:cleanup"

namespace :deploy do
    %w[start stop restart].each do |command|
        desc "#{command} unicorn server"
        task command, roles: :app, except: {no_release: true} do
            run "/etc/init.d/unicorn_#{application} #{command}"
        end
    end

    task :setup_config, roles: :app do
        sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
        sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
        run "mkdir -p #{shared_path}/config"
        put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
        put File.read("config/secrets.yml.example"), "#{shared_path}/config/secrets.yml"
        put File.read("config/github.yml.example"), "#{shared_path}/config/github.yml"
        put File.read("config/facebook.yml.example"), "#{shared_path}/config/facebook.yml"
        put File.read("config/twitter.yml.example"), "#{shared_path}/config/twitter.yml"
        put File.read("config/google.yml.example"), "#{shared_path}/config/google.yml"
        put File.read("config/devise.yml.example"), "#{shared_path}/config/devise.yml"
        put File.read("config/smtp.yml.example"), "#{shared_path}/config/smtp.yml"
        put File.read("config/recaptcha.yml.example"), "#{shared_path}/config/recaptcha.yml"
        puts "Now edit the config files in #{shared_path}."
    end

    after "deploy:setup", "deploy:setup_config"

    task :symlink_configs, roles: :app do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
        run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
        run "ln -nfs #{shared_path}/config/github.yml #{release_path}/config/github.yml"
        run "ln -nfs #{shared_path}/config/facebook.yml #{release_path}/config/facebook.yml"
        run "ln -nfs #{shared_path}/config/twitter.yml #{release_path}/config/twitter.yml"
        run "ln -nfs #{shared_path}/config/google.yml #{release_path}/config/google.yml"
        run "ln -nfs #{shared_path}/config/devise.yml #{release_path}/config/devise.yml"
        run "ln -nfs #{shared_path}/config/smtp.yml #{release_path}/config/smtp.yml"
        run "ln -nfs #{shared_path}/config/recaptcha.yml #{release_path}/config/recaptcha.yml"
    end

    after "deploy:finalize_update", "deploy:symlink_configs"

    desc "Make sure local git is in sync with remote."
    task :check_revision, roles: :web do
        unless `git rev-parse HEAD` == `git rev-parse origin/master`
            puts "WARNING: HEAD is not the same as origin/master"
            puts "Run `git push` to sync changes."
            exit
        end
    end

    before "deploy", "deploy:check_revision"

    after "deploy", "deploy:migrate"

    task :refresh_sitemaps, roles: :app do
        run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
    end

    after "deploy", "deploy:refresh_sitemaps"

    task :update_members, roles: :app do
        run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake wow:update_members"
    end

    after "deploy", "deploy:update_members"
end

namespace :rails do
    desc "Remote console"
    task :console, roles: :app do
        run_interactively "bundle exec rails console #{rails_env}"
    end

    desc "Remote dbconsole"
    task :dbconsole, roles: :app do
        run_interactively "bundle exec rails dbconsole #{rails_env}"
    end
end

namespace :nginx do
    desc "Reload nginx configs"
    task :reload do
        sudo "service nginx reload"
    end

    desc "Restart nginx server"
    task :restart do
        sudo "service nginx restart"
    end
end

def run_interactively(command)
    server ||= find_servers_for_task(current_task).first
    #app_env = fetch("default environment", {}).map{|k,v| "#{k}=\"#{v}\""}.join(' ')
    command = %Q(ssh #{user}@#{server} -p #{port} -t 'source ~/.profile && cd #{deploy_to}/current && #{command}')
    puts command
    exec command
end
