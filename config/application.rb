require File.expand_path('../boot', __FILE__)

require 'thread'
require "action_controller/railtie"
require "action_mailer/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Shdhsg
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Singapore'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators.test_framework = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true
  end
end
