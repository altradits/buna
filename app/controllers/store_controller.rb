class StoreController < ApplicationController
  def index
    @categories = Category.ordered
    @products = Product.active

    if params[:category].present?
      @category = Category.find_by(slug: params[:category])
      @products = @products.where(category: @category) if @category
    end

    if params[:q].present?
      @products = @products.search_query(params[:q])
    end

    @products = @products.order(is_featured: :desc, id: :asc)
  end

  def about
    # Cultural & ceremony guide
  end
end
