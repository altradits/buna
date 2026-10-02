class CartsController < ApplicationController
  def show
    @cart_items = load_cart_items
  end

  def add
    product_id = params[:product_id].to_s
    quantity = [ params[:quantity].to_i, 1 ].max
    format = params[:format_selected]
    roast = params[:roast_selected]

    session[:cart] ||= {}
    current_item = session[:cart][product_id] || { "quantity" => 0 }
    
    new_quantity = current_item["quantity"].to_i + quantity
    session[:cart][product_id] = {
      "quantity" => new_quantity,
      "format" => format,
      "roast" => roast
    }

    @cart_items = load_cart_items

    respond_to do |format_mime|
      format_mime.turbo_stream
      format_mime.html { redirect_back(fallback_location: root_path, notice: "Added to your Buna ceremony basket.") }
    end
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    if quantity <= 0
      session[:cart].delete(product_id)
    else
      session[:cart][product_id]["quantity"] = quantity
    end

    @cart_items = load_cart_items

    respond_to do |format_mime|
      format_mime.turbo_stream
      format_mime.html { redirect_to cart_path }
    end
  end

  def remove
    product_id = params[:product_id].to_s
    session[:cart]&.delete(product_id)
    @cart_items = load_cart_items

    respond_to do |format_mime|
      format_mime.turbo_stream
      format_mime.html { redirect_to cart_path }
    end
  end

  def clear
    session[:cart] = {}
    @cart_items = []
    respond_to do |format_mime|
      format_mime.turbo_stream
      format_mime.html { redirect_to root_path }
    end
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
