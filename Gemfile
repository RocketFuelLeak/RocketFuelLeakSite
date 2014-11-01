source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

gem 'bootstrap-sass', '~> 3.3.0.0'

gem 'font-awesome-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.5.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2'

gem 'slim-rails'

gem 'simple_form', '~> 3.1.0.rc1'
gem 'country_select'

gem 'pygments.rb'
gem 'redcarpet'

# Pagination
gem 'kaminari'

# Authentication gems
gem 'devise'
gem 'recaptcha', :require => 'recaptcha/rails'
#gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
#gem 'cancan'
gem 'cancancan', '~> 1.8'
gem 'rolify'

gem 'sitemap_generator'

# Scheduler
gem 'whenever', require: false

gem 'select2-rails'

gem 'mail_form'

gem 'httparty'

gem 'placeholder-gem'

gem 'redis'

# Maintenance
gem 'turnout'

# Monitoring
gem 'newrelic_rpm'

# Logging
gem 'lograge'

group :development do
    # Use sqlite3 as the database for Active Record in development
    gem 'sqlite3'

    # Use Guard to monitor file changes
    gem 'guard'
    gem 'guard-bundler'
    gem 'guard-rails'
    gem 'guard-livereload'

    gem 'better_errors'

    # Use Capistrano for deployment
    gem 'capistrano', '~> 3.0', require: false
    gem 'capistrano-rails', '~> 1.1', require: false
    gem 'capistrano-bundler', '~> 1.1', require: false
    gem 'capistrano-rvm', '~> 0.1', require: false
end

group :staging, :production do
    # Use PostgreSQL in staging and production
    gem 'pg'
    gem 'unicorn'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
