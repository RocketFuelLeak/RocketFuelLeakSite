# Load the Rails application.
require File.expand_path('../application', __FILE__)

SECRET_CONFIG = YAML.load_file("#{Rails.root}/config/secrets.yml")[Rails.env]
DEVISE_CONFIG = YAML.load_file("#{::Rails.root}/config/devise.yml")[::Rails.env]
GITHUB_CONFIG = YAML.load_file("#{::Rails.root}/config/github.yml")[::Rails.env]
FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env]
TWITTER_CONFIG = YAML.load_file("#{::Rails.root}/config/twitter.yml")[::Rails.env]
GOOGLE_CONFIG = YAML.load_file("#{::Rails.root}/config/google.yml")[::Rails.env]
SMTP_CONFIG = YAML.load_file("#{::Rails.root}/config/smtp.yml")[::Rails.env]
RECAPTCHA_CONFIG = YAML.load_file("#{::Rails.root}/config/recaptcha.yml")[::Rails.env]
WOWAPI_CONFIG = YML.load_file("#{::Rails.root}/config/wowapi.yml")[::Rails.env]

# Initialize the Rails application.
RocketFuelLeakSite::Application.initialize!
