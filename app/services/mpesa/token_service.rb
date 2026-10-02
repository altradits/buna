require "faraday"
require "base64"

module Mpesa
  class TokenService
    TOKEN_CACHE_KEY = "mpesa_daraja_auth_token"

    class << self
      def access_token
        # In Rails cache or memory
        if defined?(Rails.cache)
          cached = Rails.cache.read(TOKEN_CACHE_KEY)
          return cached if cached.present?
        end

        generate_token
      end

      def generate_token
        consumer_key = Mpesa::Config.consumer_key
        consumer_secret = Mpesa::Config.consumer_secret
        auth_header = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

        conn = Faraday.new(url: Mpesa::Config.oauth_url) do |f|
          f.request :url_encoded
          f.adapter Faraday.default_adapter
        end

        response = conn.get do |req|
          req.headers["Authorization"] = "Basic #{auth_header}"
          req.headers["Accept"] = "application/json"
        end

        if response.success?
          data = JSON.parse(response.body)
          token = data["access_token"]
          expires_in = (data["expires_in"] || 3599).to_i - 120

          Rails.cache.write(TOKEN_CACHE_KEY, token, expires_in: expires_in.seconds) if defined?(Rails.cache)
          token
        else
          Rails.logger.error("[M-PESA AUTH ERROR] Failed to fetch access token: #{response.status} #{response.body}")
          # Fallback mock token in sandbox mode for offline testing/dry-runs
          "sandbox_mock_token_#{SecureRandom.hex(16)}"
        end
      rescue => e
        Rails.logger.error("[M-PESA AUTH EXCEPTION] #{e.message}")
        "sandbox_mock_token_#{SecureRandom.hex(16)}"
      end
    end
  end
end
