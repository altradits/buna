source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.1.0"

# Core Rails Framework
gem "rails", "~> 7.1.3"

# PostgreSQL Database Adapter
gem "pg", "~> 1.5"

# Web Server
gem "puma", ">= 5.0"

# Hotwire / Turbo / Stimulus for reactive single-page front-end feel
gem "turbo-rails"
gem "stimulus-rails"
gem "importmap-rails"

# Tailwind CSS & Asset Pipeline for Rails
gem "tailwindcss-rails"
gem "sprockets-rails"

# User Authentication
gem "devise", "~> 4.9"
gem "bcrypt", "~> 3.1.7"

# Background Job Queue (Solid Queue for Rails 7.1+ native persistence or Sidekiq)
gem "solid_queue"

# HTTP Client for Safaricom Daraja API & East African Courier Gateways
gem "faraday", "~> 2.9"
gem "faraday-retry"

# Environment Variables & Secrets Management
gem "dotenv-rails", groups: [:development, :test]

# Cross-Origin Resource Sharing for API Callbacks
gem "rack-cors"

# JSON serialization
gem "jbuilder"

# Asset pipeline & caching
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end
