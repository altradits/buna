require "faraday"

module Logistics
  class EastAfricanCourierService
    KENYA_COUNTY_RATES = {
      "Nairobi" => 350.00,
      "Kiambu" => 450.00,
      "Machakos" => 480.00,
      "Kajiado" => 500.00,
      "Mombasa" => 650.00,
      "Nakuru" => 520.00,
      "Kisumu" => 600.00,
      "Eldoret" => 580.00,
      "Uasin Gishu" => 580.00,
      "Kilifi" => 700.00,
      "Nyeri" => 500.00,
      "Meru" => 550.00
    }.freeze

    DEFAULT_BASE_RATE = 400.00

    class << self
      def calculate_shipping(county:, total_weight_grams: 500, courier: "Fargo Courier East Africa")
        base = KENYA_COUNTY_RATES[county.to_s.strip.titleize] || DEFAULT_BASE_RATE
        
        # Add incremental weight surcharge for heavy artifacts (e.g., cast iron Fernello or Rekebot tables)
        excess_weight_kg = [ (total_weight_grams - 1000) / 1000.0, 0 ].max
        weight_surcharge = (excess_weight_kg * 120.0).round(2)

        total_kes = (base + weight_surcharge).round(2)
        total_etb = CurrencyHelper.convert_kes_to_etb(total_kes)

        {
          courier: courier,
          county: county,
          weight_grams: total_weight_grams,
          shipping_fee_kes: total_kes,
          shipping_fee_etb: total_etb,
          estimated_days: estimated_transit_days(county)
        }
      end

      def create_manifest(order)
        tracking_code = "YB-EA-#{Time.current.strftime('%y%m%d')}-#{SecureRandom.hex(3).upcase}"
        
        shipment = order.shipping_shipment || order.build_shipping_shipment
        shipment.tracking_number = tracking_code
        shipment.courier_provider = order.courier_provider.presence || "Fargo Courier East Africa"
        shipment.origin_hub = "Addis Ababa Bole Central Hub"
        shipment.border_station = "Moyale One-Stop Border Post (OSBP)"
        shipment.destination_hub = "#{order.delivery_city} (#{order.delivery_county})"
        shipment.current_checkpoint = "Addis Ababa Bole Fulfillment Hub"
        shipment.status = "manifested"
        shipment.dispatched_at = Time.current
        shipment.estimated_delivery_at = Time.current + estimated_transit_days(order.delivery_county).days
        
        initial_event = {
          timestamp: Time.current.iso8601,
          status: "manifested",
          checkpoint: "Addis Ababa Bole Central Hub",
          description: "Export consignment registered with EAC Cross-Border phytosanitary & customs clearing documentation."
        }
        shipment.tracking_events = [initial_event]
        shipment.save!

        order.update!(tracking_number: tracking_code)
        shipment
      end

      def sync_external_tracking(tracking_number)
        shipment = ShippingShipment.find_by(tracking_number: tracking_number)
        return nil unless shipment

        # Architectural hook for external courier API (Fargo, Sendy, DHL EA)
        # In production: make HTTP request to courier gateway
        shipment
      end

      private

      def estimated_transit_days(county)
        case county.to_s.downcase
        when "nairobi", "kiambu" then 3
        when "nakuru", "mombasa" then 4
        else 5
        end
      end
    end
  end
end
