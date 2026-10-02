class ProcessMpesaCallbackJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(callback_payload)
    Rails.logger.info("[SOLID QUEUE] Asynchronously processing M-Pesa Callback payload")
    result = Mpesa::CallbackHandlerService.new(callback_payload).call

    unless result.success?
      Rails.logger.warn("[SOLID QUEUE] Callback processing warning: #{result.error}")
    end
  end
end
