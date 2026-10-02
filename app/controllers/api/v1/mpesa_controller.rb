module Api
  module V1
    class MpesaController < ActionController::API
      # Safaricom IPN webhook - processes asynchronously
      def callback
        raw_payload = request.body.read
        parsed_payload = JSON.parse(raw_payload) rescue params.to_unsafe_h

        Rails.logger.info("[M-PESA IPN RECEIVED] Enqueuing callback processing worker")
        
        # Dispatch background worker (Solid Queue / ActiveJob)
        ProcessMpesaCallbackJob.perform_later(parsed_payload)

        # Immediate acknowledgement to Safaricom Daraja API
        render json: {
          ResultCode: 0,
          ResultDesc: "Callback received successfully by Yebente Buna Gateway"
        }, status: :ok
      end

      # C2B Validation Endpoint (Hakikisha verification)
      def c2b_validation
        result = Mpesa::C2bService.validate(params.to_unsafe_h)
        render json: result, status: :ok
      end

      # C2B Confirmation Endpoint (Paybill / Buy Goods)
      def c2b_confirmation
        result = Mpesa::C2bService.confirm(params.to_unsafe_h)
        render json: result, status: :ok
      end

      # Initiate STK Push via API
      def stk_push
        order = Order.find_by(order_number: params[:order_number]) || Order.find_by(id: params[:order_id])
        unless order
          return render json: { error: "Order not found" }, status: :not_found
        end

        phone = params[:phone_number].presence || order.customer_phone
        amount = params[:amount].presence || order.total_kes

        result = Mpesa::StkPushService.new(
          order: order,
          phone_number: phone,
          amount: amount
        ).call

        if result.success?
          render json: {
            success: true,
            checkout_request_id: result.checkout_request_id,
            customer_message: result.customer_message
          }, status: :ok
        else
          render json: {
            success: false,
            error: result.error
          }, status: :unprocessable_entity
        end
      end

      # Query Transaction Status
      def query
        checkout_request_id = params[:checkout_request_id]
        tx = MpesaTransaction.find_by(checkout_request_id: checkout_request_id)
        if tx
          render json: {
            found: true,
            status: tx.status,
            result_code: tx.result_code,
            receipt_number: tx.mpesa_receipt_number,
            amount: tx.amount
          }
        else
          render json: { found: false, error: "Transaction not found" }, status: :not_found
        end
      end
    end
  end
end
