class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true, index: true
      t.references :product, null: false, foreign_key: true, index: true
      t.integer :quantity, default: 1, null: false
      t.decimal :unit_price_kes, precision: 10, scale: 2, null: false
      t.decimal :unit_price_etb, precision: 10, scale: 2, null: false
      t.decimal :total_price_kes, precision: 10, scale: 2, null: false
      t.decimal :total_price_etb, precision: 10, scale: 2, null: false
      t.string :selected_format # Whole Beans, Ground, Raw Green Beans
      t.string :selected_roast  # Light, Medium, Traditional Dark Roast

      t.timestamps
    end
  end
end
