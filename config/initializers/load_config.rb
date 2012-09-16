APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :tls => APP_CONFIG['smtp_tls'],
   :address => APP_CONFIG['smtp_address'],
   :port => APP_CONFIG['smtp_port'],
   :domain => APP_CONFIG['smtp_domain'],
   :authentication => APP_CONFIG['smtp_authentication'],
   :user_name => APP_CONFIG['smtp_user'],
   :password => APP_CONFIG['smtp_password']
 }

