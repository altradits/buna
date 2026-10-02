class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :mpesa_transaction, dependent: :nullify
  has_one :shipping_shipment, dependent: :destroy

  STATUSES = %w[
    pending_payment
    payment_processing
    paid
    preparing_dispatch
    in_transit_moyale_border
    in_transit_nairobi_hub
    out_for_delivery
    delivered
    cancelled
    failed
  ].freeze

  validates :order_number, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :customer_name, :customer_email, :customer_phone, :delivery_address, presence: true

  before_validation :generate_order_number, on: :create
  before_validation :normalize_phone_number

  scope :recent, -> { order(created_at: :desc) }
  scope :paid, -> { where(status: %w[paid preparing_dispatch in_transit_moyale_border in_transit_nairobi_hub out_for_delivery delivered]) }
  scope :pending, -> { where(status: %w[pending_payment payment_processing]) }

  def mark_as_paid!(receipt_number = nil)
    update!(status: "paid")
    
    # Create or update associated shipping shipment
    shipment = shipping_shipment || build_shipping_shipment
    shipment.tracking_number ||= "YB-KE-#{SecureRandom.hex(4).upcase}"
    shipment.status = "manifested"
    shipment.origin_hub = "Addis Ababa Bole Central Hub"
    shipment.current_checkpoint = "Addis Ababa Bole Fulfillment Hub (Packing Export Consignment)"
    shipment.destination_hub = "#{delivery_city} (#{delivery_address})"
    shipment.courier_provider = courier_provider.presence || "Fargo Courier East Africa"
    shipment.dispatched_at = Time.current
    shipment.estimated_delivery_at = 3.days.from_now
    shipment.save!

    # Broadcast real-time update to Turbo Stream listeners
    broadcast_replace_to(
      "order_#{id}",
      target: "order_status_section",
      partial: "orders/status_section",
      locals: { order: self }
    )
  end

  def paid?
    %w[paid preparing_dispatch in_transit_moyale_border in_transit_nairobi_hub out_for_delivery delivered].include?(status)
  end

  def total_in(currency = "KES")
    currency.to_s.upcase == "ETB" ? total_etb : total_kes
  end

  def formatted_total(currency = "KES")
    CurrencyHelper.format_money(total_in(currency), currency)
  end

  def formatted_phone
    customer_phone
  end

  def calculate_totals!
    sub_kes = order_items.sum(&:total_price_kes)
    sub_etb = order_items.sum(&:total_price_etb)

    self.subtotal_kes = sub_kes
    self.subtotal_etb = sub_etb
    self.shipping_fee_kes ||= 350.00 # Standard Nairobi cross-border dispatch baseline
    self.shipping_fee_etb = CurrencyHelper.convert_kes_to_etb(shipping_fee_kes)
    self.total_kes = subtotal_kes + shipping_fee_kes
    self.total_etb = subtotal_etb + shipping_fee_etb
    save!
  end

  private

  def generate_order_number
    self.order_number ||= "YB-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end

  def normalize_phone_number
    return if customer_phone.blank?
    cleaned = customer_phone.to_s.gsub(/\D/, "")
    if cleaned.start_with?("0") && cleaned.length == 10
      self.customer_phone = "254#{cleaned[1..]}"
    elsif cleaned.start_with?("254") && cleaned.length == 12
      self.customer_phone = cleaned
    elsif cleaned.start_with?("7") && cleaned.length == 9
      self.customer_phone = "254#{cleaned}"
    end
  end
end
