# Safaricom M-Pesa Daraja API Initializer for Yebente Buna
module Mpesa
  class Config
    class << self
      def environment
        ENV.fetch("MPESA_ENVIRONMENT", "sandbox")
      end

      def production?
        environment == "production"
      end

      def consumer_key
        ENV.fetch("MPESA_CONSUMER_KEY", "sandbox_consumer_key")
      end

      def consumer_secret
        ENV.fetch("MPESA_CONSUMER_SECRET", "sandbox_consumer_secret")
      end

      def shortcode
        ENV.fetch("MPESA_SHORTCODE", "174379")
      end

      def passkey
        ENV.fetch("MPESA_PASSKEY", "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919")
      end

      def b2c_shortcode
        ENV.fetch("MPESA_B2C_SHORTCODE", "600000")
      end

      def initiator_name
        ENV.fetch("MPESA_INITIATOR_NAME", "testapi")
      end

      def initiator_password
        ENV.fetch("MPESA_INITIATOR_PASSWORD", "sandbox_initiator_password")
      end

      def callback_url
        ENV.fetch("MPESA_CALLBACK_URL", "https://yebente.africa/api/v1/mpesa/callback")
      end

      def c2b_validation_url
        ENV.fetch("MPESA_C2B_VALIDATION_URL", "https://yebente.africa/api/v1/mpesa/c2b_validation")
      end

      def c2b_confirmation_url
        ENV.fetch("MPESA_C2B_CONFIRMATION_URL", "https://yebente.africa/api/v1/mpesa/c2b_confirmation")
      end

      def base_url
        if production?
          "https://api.safaricom.co.ke"
        else
          "https://sandbox.safaricom.co.ke"
        end
      end

      def oauth_url
        "#{base_url}/oauth/v1/generate?grant_type=client_credentials"
      end

      def stk_push_url
        "#{base_url}/mpesa/stkpush/v1/processrequest"
      end

      def stk_query_url
        "#{base_url}/mpesa/stkpushquery/v1/query"
      end

      def c2b_register_url
        "#{base_url}/mpesa/c2b/v1/registerurl"
      end
    end
  end
end
