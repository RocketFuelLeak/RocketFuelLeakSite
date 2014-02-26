Recaptcha.configure do |config|
    config.public_key = RECAPTCHA_CONFIG['public_key']
    config.private_key = RECAPTCHA_CONFIG['private_key']
end
