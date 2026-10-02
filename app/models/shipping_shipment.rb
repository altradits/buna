class ShippingShipment < ApplicationRecord
  belongs_to :order

  STATUSES = %w[
    manifested
    dispatched_from_addis
    customs_cleared_moyale
    arrived_nairobi_hub
    out_for_delivery
    delivered
  ].freeze

  CHECKPOINTS = [
    { code: "manifested", label: "Addis Ababa Central Hub", desc: "Buna Ceremony Artifacts & Fresh Roasts Packed", amharic: "አዲስ አበባ ቦሌ ማዕከል" },
    { code: "dispatched_from_addis", label: "Hawassa Transit Corridor", desc: "Cross-regional refrigerated transit to Southern Border", amharic: "ሐዋሳ መስመር" },
    { code: "customs_cleared_moyale", label: "Moyale OSBP Border Post", desc: "Kenya-Ethiopia One-Stop Border Post Customs Clearance", amharic: "ሞያሌ ድንበር" },
    { code: "arrived_nairobi_hub", label: "Nairobi Industrial Logistics Center", desc: "Received at central Kenyan distribution sorting warehouse", amharic: "ናይሮቢ ማዕከል" },
    { code: "out_for_delivery", label: "Dispatched with Local Courier", desc: "Fargo / Sendy courier en route to delivery address", amharic: "በማድረስ ላይ" },
    { code: "delivered", label: "Delivered to Customer", desc: "Package handed over to recipient in Kenya", amharic: "ደርሷል" }
  ].freeze

  validates :tracking_number, presence: true, uniqueness: true

  def advance_checkpoint!(new_status, notes = nil)
    self.status = new_status
    event = {
      timestamp: Time.current.iso8601,
      status: new_status,
      checkpoint: current_checkpoint,
      notes: notes
    }
    self.tracking_events = (tracking_events || []) << event
    self.delivered_at = Time.current if new_status == "delivered"
    save!
  end

  def progress_percentage
    case status
    when "manifested" then 15
    when "dispatched_from_addis" then 35
    when "customs_cleared_moyale" then 60
    when "arrived_nairobi_hub" then 80
    when "out_for_delivery" then 90
    when "delivered" then 100
    else 10
    end
  end
end
