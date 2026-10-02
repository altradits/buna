require "faraday"
require "base64"

module Mpesa
  class StkPushService
    attr_reader :order, :phone_number, :amount, :account_reference, :transaction_desc

    def initialize(order:, phone_number:, amount: nil, account_reference: nil, transaction_desc: "Yebente Buna Coffee")
      @order = order
      @phone_number = format_phone(phone_number)
      @amount = (amount || order.total_kes).to_i
      @account_reference = account_reference || order.order_number
      @transaction_desc = transaction_desc
    end

    def call
      token = Mpesa::TokenService.access_token
      timestamp = Time.current.strftime("%Y%m%d%H%M%S")
      shortcode = Mpesa::Config.shortcode
      passkey = Mpesa::Config.passkey
      password = Base64.strict_encode64("#{shortcode}#{passkey}#{timestamp}")

      payload = {
        "BusinessShortCode" => shortcode,
        "Password" => password,
        "Timestamp" => timestamp,
        "TransactionType" => "CustomerPayBillOnline",
        "Amount" => amount,
        "PartyA" => phone_number,
        "PartyB" => shortcode,
        "PhoneNumber" => phone_number,
        "CallBackURL" => Mpesa::Config.callback_url,
        "AccountReference" => account_reference,
        "TransactionDesc" => transaction_desc
      }

      conn = Faraday.new(url: Mpesa::Config.stk_push_url) do |f|
        f.request :json
        f.adapter Faraday.default_adapter
      end

      response = conn.post do |req|
        req.headers["Authorization"] = "Bearer #{token}"
        req.headers["Content-Type"] = "application/json"
        req.body = payload.to_json
      end

      handle_response(response)
    rescue => e
      Rails.logger.error("[M-PESA STK PUSH EXCEPTION] #{e.class}: #{e.message}")
      simulate_or_fail(e)
    end

    private

    def handle_response(response)
      data = JSON.parse(response.body) rescue {}
      
      if response.success? && (data["ResponseCode"] == "0" || data["ResponseCode"] == 0)
        checkout_request_id = data["CheckoutRequestID"]
        merchant_request_id = data["MerchantRequestID"]

        # Record initiated transaction
        tx = MpesaTransaction.create!(
          order: order,
          merchant_request_id: merchant_request_id,
          checkout_request_id: checkout_request_id,
          transaction_type: "STKPush",
          amount: amount,
          phone_number: phone_number,
          status: "initiated"
        )

        order.update!(status: "payment_processing") if order.present?

        OpenStruct.new(
          success?: true,
          checkout_request_id: checkout_request_id,
          merchant_request_id: merchant_request_id,
          customer_message: data["CustomerMessage"] || "Success. Request accepted for processing",
          transaction: tx
        )
      else
        error_msg = data["errorMessage"] || data["ResponseDescription"] || "M-Pesa STK Push request failed"
        Rails.logger.warn("[M-PESA STK PUSH REJECTED] Code: #{data['ResponseCode']}, Msg: #{error_msg}")

        # In sandbox environment without live credentials, handle gracefully with a simulated transaction for testing
        if !Mpesa::Config.production? && ENV["ALLOW_SANDBOX_SIMULATION"] == "true"
          return simulate_sandbox_success
        end

        OpenStruct.new(
          success?: false,
          error: error_msg,
          response_code: data["ResponseCode"]
        )
      end
    end

    def simulate_or_fail(exception)
      if !Mpesa::Config.production? && ENV["ALLOW_SANDBOX_SIMULATION"] == "true"
        simulate_sandbox_success
      else
        OpenStruct.new(success?: false, error: exception.message)
      end
    end

    def simulate_sandbox_success
      sim_id = "ws_CO_#{Time.current.strftime('%d%m%Y%H%M%S')}_#{SecureRandom.hex(4)}"
      tx = MpesaTransaction.create!(
        order: order,
        merchant_request_id: "SANDBOX-MR-#{SecureRandom.hex(4)}",
        checkout_request_id: sim_id,
        transaction_type: "STKPush",
        amount: amount,
        phone_number: phone_number,
        status: "initiated"
      )
      order.update!(status: "payment_processing") if order.present?

      OpenStruct.new(
        success?: true,
        checkout_request_id: sim_id,
        customer_message: "Sandbox test prompt sent to #{phone_number}",
        transaction: tx
      )
    end

    def format_phone(number)
      clean = number.to_s.gsub(/\D/, "")
      if clean.start_with?("0") && clean.length == 10
        "254#{clean[1..]}"
      elsif clean.start_with?("254") && clean.length == 12
        clean
      elsif clean.start_with?("7") && clean.length == 9
        "254#{clean}"
      else
        clean
      end
    end
  end
end
