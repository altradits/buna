module Admin
  class DashboardController < BaseController
    def index
      @total_orders = Order.count
      @paid_orders_count = Order.paid.count
      @pending_orders_count = Order.pending.count
      @total_revenue_kes = Order.paid.sum(:total_kes)
      @total_revenue_etb = Order.paid.sum(:total_etb)

      @recent_orders = Order.recent.limit(10)
      @recent_mpesa_transactions = MpesaTransaction.recent.limit(10)
      @active_shipments = ShippingShipment.where.not(status: "delivered").limit(10)
    end
  end
end
