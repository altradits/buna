module Admin
  class OrdersController < BaseController
    def index
      @orders = Order.recent
      if params[:status].present?
        @orders = @orders.where(status: params[:status])
      end
    end

    def show
      @order = Order.find_by!(order_number: params[:id]) || Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @order = Order.find(params[:id])
    end
  end
end
