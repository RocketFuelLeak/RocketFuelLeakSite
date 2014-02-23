require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module RocketFuelLeakSite
  class Application < Rails::Application
    config.time_zone = 'Stockholm'
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'SAMEORIGIN',
        'X-XSS-Protection' => '1; mode=block',
        'X-Content-Type-Options' => 'nosniff',
        'X-UA-Compatible'  => 'IE=edge,chrome=1'
    }
  end
end
