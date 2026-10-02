class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  before_action :set_currency
  helper_method :current_currency, :current_cart, :cart_count, :cart_subtotal, :format_currency

  private

  def set_currency
    if params[:currency].present? && %w[KES ETB].include?(params[:currency].to_s.upcase)
      session[:currency] = params[:currency].to_s.upcase
    end
    @current_currency = session[:currency] || "KES"
  end

  def current_currency
    @current_currency ||= session[:currency] || "KES"
  end

  def format_currency(amount, curr = nil)
    CurrencyHelper.format_money(amount, curr || current_currency)
  end

  # Session-based cart storage
  def current_cart
    session[:cart] ||= {}
    # Structure: { "product_id" => { "quantity" => 2, "format" => "Ground", "roast" => "Medium" } }
  end

  def cart_count
    current_cart.values.sum { |item| item["quantity"].to_i }
  end

  def cart_subtotal
    total = 0.0
    current_cart.each do |product_id, item|
      product = Product.find_by(id: product_id)
      next unless product
      price = current_currency == "ETB" ? product.price_etb : product.price_kes
      total += price * item["quantity"].to_i
    end
    total
  end
end
