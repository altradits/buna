class CreateShippingShipments < ActiveRecord::Migration[7.1]
  def change
    create_table :shipping_shipments do |t|
      t.references :order, null: false, foreign_key: true, index: true
      t.string :tracking_number, null: false
      t.string :courier_provider, default: "Fargo Courier East Africa", null: false
      t.string :service_level, default: "CrossBorderExpress"
      
      # Regional Waypoints
      t.string :origin_hub, default: "Addis Ababa Bole Central Hub"
      t.string :border_station, default: "Moyale One-Stop Border Post (OSBP)"
      t.string :destination_hub, default: "Nairobi Industrial Area Logistics Center"
      t.string :current_checkpoint
      t.string :status, default: "manifested", null: false # manifested, dispatched_from_addis, customs_cleared_moyale, arrived_nairobi_hub, out_for_delivery, delivered

      t.datetime :dispatched_at
      t.datetime :estimated_delivery_at
      t.datetime :delivered_at

      t.json :tracking_events, default: []
      t.text :consignment_notes

      t.timestamps
    end

    add_index :shipping_shipments, :tracking_number, unique: true
    add_index :shipping_shipments, :status
  end
end
