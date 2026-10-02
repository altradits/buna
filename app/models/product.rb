class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sku, presence: true, uniqueness: true
  validates :price_kes, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price_etb, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :generate_slug_and_sku, on: :create
  before_validation :sync_etb_price

  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :featured, -> { active.where(is_featured: true) }
  scope :coffee_only, -> { joins(:category).where("categories.slug LIKE ?", "%coffee%") }
  scope :by_origin, ->(zone) { where(origin_zone: zone) if zone.present? }
  scope :by_roast, ->(roast) { where(roast_profile: roast) if roast.present? }
  scope :by_format, ->(fmt) { where(bean_format: fmt) if fmt.present? }

  scope :search_query, ->(query) {
    if query.present?
      q = "%#{query.downcase}%"
      where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ? OR LOWER(products.tasting_notes) LIKE ? OR LOWER(products.origin_zone) LIKE ? OR LOWER(products.amharic_name) LIKE ?", q, q, q, q, q)
    end
  }

  def to_param
    slug
  end

  def in_stock?
    stock_quantity > 0
  end

  def coffee?
    origin_zone.present? || roast_profile.present? || bean_format.present?
  end

  def tasting_notes_array
    return [] if tasting_notes.blank?
    tasting_notes.split(",").map(&:strip)
  end

  def price_in(currency = "KES")
    currency.to_s.upcase == "ETB" ? price_etb : price_kes
  end

  def formatted_price(currency = "KES")
    CurrencyHelper.format_money(price_in(currency), currency)
  end

  private

  def generate_slug_and_sku
    self.slug ||= name.to_s.parameterize if name.present?
    self.sku ||= "YB-#{origin_zone.presence || category&.slug || 'ACC'}-#{SecureRandom.hex(3).upcase}"
  end

  def sync_etb_price
    if price_kes.present? && (price_etb.blank? || price_etb.zero?)
      self.price_etb = CurrencyHelper.convert_kes_to_etb(price_kes)
    end
  end
end
