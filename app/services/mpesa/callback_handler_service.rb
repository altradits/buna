module Mpesa
  class CallbackHandlerService
    attr_reader :payload

    def initialize(payload)
      @payload = payload.is_a?(String) ? (JSON.parse(payload) rescue {}) : (payload || {})
    end

    def call
      callback_data = payload.dig("Body", "stkCallback")
      unless callback_data
        Rails.logger.error("[M-PESA CALLBACK] Invalid payload structure: #{payload.inspect}")
        return OpenStruct.new(success?: false, error: "Invalid callback payload")
      end

      checkout_request_id = callback_data["CheckoutRequestID"]
      merchant_request_id = callback_data["MerchantRequestID"]
      result_code = callback_data["ResultCode"].to_i
      result_desc = callback_data["ResultDesc"]

      transaction = MpesaTransaction.find_by(checkout_request_id: checkout_request_id) ||
                    MpesaTransaction.find_by(merchant_request_id: merchant_request_id)

      unless transaction
        Rails.logger.warn("[M-PESA CALLBACK] Transaction not found for CheckoutRequestID: #{checkout_request_id}")
        return OpenStruct.new(success?: false, error: "Transaction not found")
      end

      transaction.result_code = result_code
      transaction.result_desc = result_desc
      transaction.raw_callback_payload = payload

      if result_code == 0
        items = callback_data.dig("CallbackMetadata", "Item") || []
        items_hash = items.each_with_object({}) { |item, h| h[item["Name"]] = item["Value"] }

        receipt_number = items_hash["MpesaReceiptNumber"]
        trans_date_raw = items_hash["TransactionDate"].to_s
        amount = items_hash["Amount"]
        phone = items_hash["PhoneNumber"].to_s

        parsed_date = parse_mpesa_date(trans_date_raw)

        transaction.mpesa_receipt_number = receipt_number
        transaction.transaction_date = parsed_date
        transaction.amount = amount if amount.present?
        transaction.phone_number = phone if phone.present?
        transaction.status = "success"
        transaction.save!

        if transaction.order.present?
          transaction.order.mark_as_paid!(receipt_number)
          DispatchOrderFulfillmentJob.perform_later(transaction.order_id) if defined?(DispatchOrderFulfillmentJob)
          SendOrderNotificationJob.perform_later(transaction.order_id) if defined?(SendOrderNotificationJob)
        end

        Rails.logger.info("[M-PESA PAYMENT SUCCESS] Order: #{transaction.order&.order_number}, Receipt: #{receipt_number}, Amount: #{amount}")
        OpenStruct.new(success?: true, transaction: transaction)
      else
        transaction.status = result_code == 1032 ? "cancelled" : "failed"
        transaction.save!

        if transaction.order.present? && transaction.order.status == "payment_processing"
          transaction.order.update!(status: "failed")
        end

        Rails.logger.warn("[M-PESA PAYMENT FAILED] Code: #{result_code}, Desc: #{result_desc}")
        OpenStruct.new(success?: false, result_code: result_code, error: result_desc)
      end
    rescue => e
      Rails.logger.error("[M-PESA CALLBACK ERROR] #{e.class}: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
      OpenStruct.new(success?: false, error: e.message)
    end

    private

    def parse_mpesa_date(date_str)
      return Time.current if date_str.blank?
      DateTime.strptime(date_str, "%Y%m%d%H%M%S")
    rescue
      Time.current
    end
  end
end
