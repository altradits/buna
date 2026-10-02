class DispatchOrderFulfillmentJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order

    Rails.logger.info("[LOGISTICS] Registering export consignment for Order ##{order.order_number}")
    Logistics::EastAfricanCourierService.create_manifest(order)
  end
end
