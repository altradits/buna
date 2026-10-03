require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"]
  # or in config/master.key.
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false if config.respond_to?(:assets)

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "https://assets.yebente.africa"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system or S3
  config.active_storage.service = :local

  # Mount Action Cable outside main process or with redis
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = ENV["RAILS_FORCE_SSL"].to_s == "true"

  # Log to STDOUT with the current request id as a default log tag.
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use Solid Queue or async for background processing
  config.active_job.queue_adapter = ENV.fetch("ACTIVE_JOB_ADAPTER", "async").to_sym

  # Secret key base fallback if not provided via environment variable
  config.secret_key_base = ENV["SECRET_KEY_BASE"].presence || "7c9b8e21a4f039d5e68201bfa8293d047e1c6b54a8e29304d9e03f1b5c2a84e68f3a1d9c0b2e4f6a8b0c2d4e6f8a0b2c4d6e8f0a2b4c6d8e0f2a4b6c8d0e2f4a"

  # Action Mailer config
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "yebente.africa") }

  # Enable locale fallbacks for I18n
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  config.active_record.sqlite3_production_warning = false if config.active_record.respond_to?(:sqlite3_production_warning=)
end
