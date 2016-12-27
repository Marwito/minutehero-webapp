Mailjet.configure do |config|
  config.api_key = ENV['mailjet_api_key']
  config.secret_key = ENV['mailjet_secret_key']
  config.default_from = ENV['admin_email']
end