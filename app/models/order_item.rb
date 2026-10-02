class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_kes, :unit_price_etb, presence: true

  before_validation :calculate_totals

  def calculate_totals
    if product.present?
      self.unit_price_kes ||= product.price_kes
      self.unit_price_etb ||= product.price_etb
    end

    self.total_price_kes = (unit_price_kes || 0) * (quantity || 1)
    self.total_price_etb = (unit_price_etb || 0) * (quantity || 1)
  end

  def price_in(currency = "KES")
    currency.to_s.upcase == "ETB" ? total_price_etb : total_price_kes
  end

  def formatted_total(currency = "KES")
    CurrencyHelper.format_money(price_in(currency), currency)
  end
end
