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

  def display_image_url
    return image_url if image_url.present?

    s = "#{slug} #{name}".downcase
    case s
    when /green-unroasted|raw-green|raw green|green beans/
      "/images/products/coffee-green-beans.jpg"
    when /fine-ground|jebena-fine|ground-format|fine ground/
      "/images/products/coffee-ground.jpg"
    when /heirloom|roasted-whole|dark-roast|medium-roast|bensa|longberry|highland-forest|biosphere|whole beans|roasted/
      "/images/products/coffee-roasted-beans.jpg"
    when /gondar.*jebena|gondar clay/
      "/images/products/jebena-gondar.jpg"
    when /harari.*jebena|harar.*jebena|flat-bottom/
      "/images/products/jebena-harari.jpg"
    when /menkeshkesh|roasting-pan|roasting pan/
      "/images/products/menkeshkesh-pan.jpg"
    when /fernello|brazier|charcoal/
      "/images/products/fernello-brazier.jpg"
    when /kettle|brass-pouring|pouring kettle/
      "/images/products/jebena-gondar.jpg"
    when /sini|cini|cups|saucers/
      "/images/products/sini-cups-set.jpg"
    when /rekebot|coffee table|porcelain.*tray/
      "/images/products/rekebot-table.jpg"
    when /mashesha|stirring|stirrer/
      "/images/products/mashesha-stirrer.jpg"
    when /conical-burr|electric-grinder|electric grinder/
      "/images/products/electric-grinder.jpg"
    when /travel-grinder|brass-cylindrical|cylindrical travel/
      "/images/products/brass-hand-grinder.jpg"
    when /hand-mill|manual-buna|hand mill/
      "/images/products/cast-iron-grinder.jpg"
    when /frankincense|etan|olibanum/
      "/images/products/frankincense-resin.jpg"
    when /burner|gidich|mubakhar|incense burner/
      "/images/products/clay-incense-burner.jpg"
    when /myrrh|karbe/
      "/images/products/myrrh-resin.jpg"
    when /tenadam|rue/
      "/images/products/tenadam-herbs.jpg"
    when /korerima|spice infusion/
      "/images/products/korerima-spice.jpg"
    when /coals|olive-wood-shavings|coconut coals/
      "/images/products/olive-wood-coals.jpg"
    when /ketema|floor mat/
      "/images/products/ketema-floor-mat.jpg"
    when /tibeb|table runner/
      "/images/products/tibeb-table-runner.jpg"
    when /barchuma|wooden.*stool/
      "/images/products/wooden-barchuma-stool.jpg"
    when /cushion|pouf/
      "/images/products/velvet-floor-cushion.jpg"
    else
      if coffee?
        bean_format == "Raw Green Beans" ? "/images/products/coffee-green-beans.jpg" : "/images/products/coffee-roasted-beans.jpg"
      else
        "/images/products/jebena-gondar.jpg"
      end
    end
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
