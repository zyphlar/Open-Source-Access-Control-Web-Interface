require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Dooraccess
  class Application < Rails::Application
    # config.active_support.cache_format_version = 7.0
    config.load_defaults 7.1
    config.time_zone = "America/Phoenix"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :pass]

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = "1.1"
  end
end
