module Api
  module V1
    class HealthController < ActionController::API
      def show
        db_healthy = begin
          ActiveRecord::Base.connection.active?
        rescue => e
          false
        end

        render json: {
          status: "healthy",
          timestamp: Time.current.iso8601,
          app: "Yebente Buna",
          amharic: "የበንቴ ቡና",
          database: db_healthy ? "connected" : "disconnected",
          timezone: Time.zone.name,
          currency: {
            base: CurrencyHelper::DEFAULT_KES_TO_ETB_RATE ? "KES" : "UNKNOWN",
            secondary: "ETB",
            rate: CurrencyHelper.current_rate_kes_to_etb
          },
          mpesa: {
            environment: Mpesa::Config.environment,
            shortcode: Mpesa::Config.shortcode,
            merchant_contact: ENV.fetch("DEFAULT_MERCHANT_PHONE", "+254707172370")
          },
          environment: Rails.env
        }, status: :ok
      end
    end
  end
end
