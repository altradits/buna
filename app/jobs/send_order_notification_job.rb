class SendOrderNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    admin_email = ENV.fetch("ADMIN_EMAIL", "yebente@gmail.com")
    merchant_phone = ENV.fetch("DEFAULT_MERCHANT_PHONE", "+254707172370")

    Rails.logger.info("[NOTIFICATION] Payment Confirmed! Notifying Admin: #{admin_email}, Merchant: #{merchant_phone}, Customer: #{order.customer_email}")
    # In production with ActionMailer:
    # OrderMailer.confirmation_email(order).deliver_later
    # OrderMailer.admin_notification_email(order, admin_email).deliver_later
  end
end
