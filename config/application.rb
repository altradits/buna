require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups) if defined?(Bundler)

module YebenteBuna
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7.1
    config.load_defaults 7.1

    # Regional Timezone Configuration - Set strictly to Africa/Nairobi (EAT, UTC+3)
    config.time_zone = ENV.fetch("APPLICATION_TIMEZONE", "Africa/Nairobi")
    config.active_record.default_timezone = :utc

    # Autoload services, builders, and logistics modules
    config.autoload_paths << Rails.root.join("app/services")
    config.eager_load_paths << Rails.root.join("app/services")

    # Use Solid Queue / Sidekiq for background worker pattern
    config.active_job.queue_adapter = ENV.fetch("QUEUE_ADAPTER", "solid_queue").to_sym

    # Application identity & branding metadata
    config.x.app_name = ENV.fetch("APP_NAME", "Yebente Buna")
    config.x.amharic_name = ENV.fetch("APP_AMHARIC_NAME", "የበንቴ ቡና")
    config.x.merchant_phone = ENV.fetch("DEFAULT_MERCHANT_PHONE", "+254707172370")
    config.x.admin_email = ENV.fetch("ADMIN_EMAIL", "yebente@gmail.com")
    config.x.base_currency = ENV.fetch("BASE_CURRENCY", "KES")
    config.x.secondary_currency = ENV.fetch("SECONDARY_CURRENCY", "ETB")
    config.x.kes_to_etb_rate = ENV.fetch("KES_TO_ETB_RATE", "0.88").to_f
    config.x.etb_to_kes_rate = ENV.fetch("ETB_TO_KES_RATE", "1.136").to_f

    # Session store configuration
    config.session_store :cookie_store, key: "_yebente_buna_session", expire_after: 14.days

    # Assets pipeline configuration
    config.assets.css_compressor = nil
  end
end
