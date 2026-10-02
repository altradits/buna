class StoreController < ApplicationController
  def index
    @categories = Category.ordered
    @featured_coffees = Product.featured.coffee_only.limit(4)
    @featured_artifacts = Product.featured.where(origin_zone: nil).limit(4)
    @all_featured = Product.featured.limit(8)
    @coffee_zones = %w[Sidamo Yirgacheffe Harrar Limu Kaffa]
  end

  def about
    # Cultural & ceremony guide
  end
end
