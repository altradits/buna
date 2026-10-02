class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: true, index: true
      t.string :order_number, null: false
      t.string :status, default: "pending_payment", null: false
      
      # Multi-Currency Financials
      t.string :currency_used, default: "KES", null: false
      t.decimal :exchange_rate_applied, precision: 10, scale: 4, default: 0.8800
      t.decimal :subtotal_kes, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :subtotal_etb, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :shipping_fee_kes, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :shipping_fee_etb, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total_kes, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total_etb, precision: 10, scale: 2, default: 0.0, null: false

      # Customer Contact & Kenyan Delivery Details
      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.string :customer_phone, null: false # e.g. 254707172370
      t.text :delivery_address, null: false
      t.string :delivery_city, default: "Nairobi", null: false
      t.string :delivery_county, default: "Nairobi"
      t.string :postal_code

      # East African Cross-Border Logistics Routing
      t.string :origin_hub, default: "Addis Ababa Bole Central Hub"
      t.string :border_transit_hub, default: "Moyale One-Stop Border Post"
      t.string :destination_hub, default: "Nairobi Distribution Hub"
      t.string :courier_provider, default: "Fargo Courier East Africa"
      t.string :tracking_number

      t.text :order_notes

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :status
    add_index :orders, :customer_phone
    add_index :orders, :tracking_number
  end
end
