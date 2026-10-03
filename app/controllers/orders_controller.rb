class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :status, :retry_stk, :track]

  def show
    @transaction = @order.mpesa_transaction
    @shipment = @order.shipping_shipment
    @stk_prompted = params[:stk] == "prompted"
  end

  def status
    render json: {
      id: @order.id,
      order_number: @order.order_number,
      status: @order.status,
      paid: @order.paid?,
      receipt_number: @order.mpesa_transaction&.mpesa_receipt_number,
      message: @order.paid? ? "Payment confirmed." : "Awaiting authorization..."
    }
  end

  def retry_stk
    phone = params[:phone_number].presence || @order.customer_phone
    result = Mpesa::StkPushService.new(
      order: @order,
      phone_number: phone,
      amount: @order.total_kes
    ).call

    if result.success?
      redirect_to order_path(@order, stk: "prompted", phone: phone),
                  notice: "Payment prompt dispatched to #{phone}."
    else
      redirect_to order_path(@order), alert: "Could not send payment prompt: #{result.error}"
    end
  end

  def track
    @shipment = @order.shipping_shipment || Logistics::EastAfricanCourierService.create_manifest(@order)
    @checkpoints = ShippingShipment::CHECKPOINTS
  end

  private

  def set_order
    @order = Order.find_by!(order_number: params[:id]) || Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @order = Order.find(params[:id])
  end
end
