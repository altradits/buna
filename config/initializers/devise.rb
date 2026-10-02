# frozen_string_literal: true

require "devise/orm/active_record"

Devise.setup do |config|
  # The secret key used by Devise.
  config.secret_key = ENV.fetch("SECRET_KEY_BASE", "a" * 128)

  # Configure the mailer
  config.mailer_sender = ENV.fetch("ADMIN_EMAIL", "yebente@gmail.com")

  # Configure which authentication keys are valid.
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Skip session storage for API requests
  config.skip_session_storage = [:http_auth]

  # Number of authentication tries before locking an account
  config.stretches = Rails.env.test? ? 1 : 12

  # Send a notification email when the user's password is changed
  config.send_password_change_notification = false

  # Time interval for password reset tokens
  config.reset_password_within = 6.hours

  # Sign out via DELETE or GET
  config.sign_out_via = :delete

  # Hotwire / Turbo integration for Devise
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
