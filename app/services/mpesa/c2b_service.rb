module Mpesa
  class C2bService
    class << self
      def validate(params)
        bill_ref = params["BillRefNumber"] || params["AccountReference"]
        amount = params["TransAmount"].to_f

        # Check if matching pending order exists
        order = Order.find_by(order_number: bill_ref)
        if order.present?
          { ResultCode: 0, ResultDesc: "Accepted for Order #{bill_ref}" }
        else
          # Allow general Paybill deposits to merchant account
          { ResultCode: 0, ResultDesc: "Accepted general merchant payment" }
        end
      end

      def confirm(params)
        trans_id = params["TransID"]
        bill_ref = params["BillRefNumber"]
        amount = params["TransAmount"].to_f
        phone = params["MSISDN"]
        first_name = params["FirstName"]
        trans_time_raw = params["TransTime"].to_s

        order = Order.find_by(order_number: bill_ref)

        tx = MpesaTransaction.find_or_initialize_by(mpesa_receipt_number: trans_id)
        tx.order = order
        tx.merchant_request_id ||= "C2B-#{trans_id}"
        tx.checkout_request_id ||= "C2B-REF-#{SecureRandom.hex(6)}"
        tx.transaction_type = "CustomerPayBillOnline"
        tx.amount = amount
        tx.phone_number = phone
        tx.result_code = 0
        tx.result_desc = "C2B Payment Confirmed from #{first_name}"
        tx.transaction_date = parse_c2b_date(trans_time_raw)
        tx.status = "success"
        tx.raw_callback_payload = params
        tx.save!

        if order.present?
          order.mark_as_paid!(trans_id)
        end

        { ResultCode: 0, ResultDesc: "Confirmation received successfully" }
      end

      private

      def parse_c2b_date(str)
        DateTime.strptime(str, "%Y%m%d%H%M%S") rescue Time.current
      end
    end
  end
end
