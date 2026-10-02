class CheckoutsController < ApplicationController
  def new
    if current_cart.empty?
      redirect_to root_path, alert: "Your cart is empty. Explore our authentic Ethiopian Buna selection first."
      return
    end

    @counties = Logistics::EastAfricanCourierService::KENYA_COUNTY_RATES.keys
    @selected_county = params[:county].presence || "Nairobi"
    @shipping_quote = Logistics::EastAfricanCourierService.calculate_shipping(county: @selected_county)
    @cart_items = load_cart_items
    @total_kes = @cart_items.sum { |i| i[:total_kes] } + @shipping_quote[:shipping_fee_kes]
    @total_etb = @cart_items.sum { |i| i[:total_etb] } + @shipping_quote[:shipping_fee_etb]
    @default_phone = params[:phone].presence || ENV.fetch("DEFAULT_MERCHANT_PHONE", "+254707172370")
  end

  def create
    if current_cart.empty?
      redirect_to root_path, alert: "Your cart is empty."
      return
    end

    county = params[:delivery_county].presence || "Nairobi"
    city = params[:delivery_city].presence || "Nairobi"
    address = params[:delivery_address].presence || "Nairobi Delivery Address"
    customer_name = params[:customer_name].presence || "Valued Buna Connoisseur"
    customer_email = params[:customer_email].presence || "customer@example.co.ke"
    phone_number = params[:customer_phone].presence || ENV.fetch("DEFAULT_MERCHANT_PHONE", "+254707172370")
    courier = params[:courier_provider].presence || "Fargo Courier East Africa"

    # Compute shipping
    cart_items = load_cart_items
    total_weight = cart_items.sum { |i| (i[:product].weight_grams || 500) * i[:quantity] }
    shipping_quote = Logistics::EastAfricanCourierService.calculate_shipping(
      county: county,
      total_weight_grams: total_weight,
      courier: courier
    )

    ActiveRecord::Base.transaction do
      @order = Order.create!(
        user: (defined?(current_user) ? current_user : nil),
        customer_name: customer_name,
        customer_email: customer_email,
        customer_phone: phone_number,
        delivery_address: address,
        delivery_city: city,
        delivery_county: county,
        courier_provider: courier,
        status: "pending_payment",
        currency_used: current_currency,
        exchange_rate_applied: CurrencyHelper.current_rate_kes_to_etb,
        shipping_fee_kes: shipping_quote[:shipping_fee_kes],
        shipping_fee_etb: shipping_quote[:shipping_fee_etb]
      )

      cart_items.each do |item|
        @order.order_items.create!(
          product: item[:product],
          quantity: item[:quantity],
          unit_price_kes: item[:product].price_kes,
          unit_price_etb: item[:product].price_etb,
          selected_format: item[:format],
          selected_roast: item[:roast]
        )
      end

      @order.calculate_totals!
    end

    # Clear shopping cart
    session[:cart] = {}

    # Initiate Safaricom M-Pesa STK Push
    stk_result = Mpesa::StkPushService.new(
      order: @order,
      phone_number: phone_number,
      amount: @order.total_kes
    ).call

    if stk_result.success?
      redirect_to order_path(@order, stk: "prompted", phone: phone_number),
                  notice: "M-Pesa STK Push initiated! Please check your phone #{phone_number} to enter your M-Pesa PIN."
    else
      redirect_to order_path(@order, stk: "manual", phone: phone_number),
                  alert: "M-Pesa Express prompt could not be dispatched: #{stk_result.error}. You can retry or pay via Paybill 174379."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_checkout_path, alert: "Validation error: #{e.record.errors.full_messages.join(', ')}"
  end

  private

  def load_cart_items
    items = []
    current_cart.each do |product_id, item_data|
      product = Product.find_by(id: product_id)
      next unless product
      items << {
        product: product,
        quantity: item_data["quantity"].to_i,
        format: item_data["format"],
        roast: item_data["roast"],
        total_kes: product.price_kes * item_data["quantity"].to_i,
        total_etb: product.price_etb * item_data["quantity"].to_i
      }
    end
    items
  end
end
