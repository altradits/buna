class ProductsController < ApplicationController
  def index
    @categories = Category.ordered
    @products = Product.active

    if params[:category].present?
      @category = Category.find_by(slug: params[:category])
      @products = @products.where(category: @category) if @category
    end

    if params[:zone].present?
      @products = @products.by_origin(params[:zone])
    end

    if params[:roast].present?
      @products = @products.by_roast(params[:roast])
    end

    if params[:format].present?
      @products = @products.by_format(params[:format])
    end

    if params[:q].present?
      @products = @products.search_query(params[:q])
    end

    @products = @products.order(is_featured: :desc, created_at: :desc)
  end

  def show
    @product = Product.find_by!(slug: params[:id])
    @related_products = Product.active.where(category_id: @product.category_id).where.not(id: @product.id).limit(4)
  end
end
