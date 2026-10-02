class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.string :amharic_name
      t.string :slug, null: false
      t.string :sku, null: false
      t.string :short_description
      t.text :description
      
      # Pricing & Multi-Currency Storage
      t.decimal :price_kes, precision: 10, scale: 2, null: false
      t.decimal :price_etb, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, default: 0, null: false
      t.integer :weight_grams, default: 500
      t.boolean :is_featured, default: false
      t.boolean :is_active, default: true

      # Coffee Specific Taxonomy Attributes
      t.string :origin_zone        # Sidamo, Yirgacheffe, Harrar, Limu, Kaffa
      t.string :roast_profile      # Light, Medium, Traditional Dark Roast
      t.string :bean_format        # Raw Green Beans, Roasted Whole Beans, Ground
      t.string :processing_method  # Washed, Natural
      t.string :elevation          # e.g. 1,900m - 2,200m ASL
      t.text :tasting_notes        # e.g. Jasmine floral, Bergamot citrus, Dried blueberry

      # Traditional Artifacts & Hardware Attributes
      t.string :material           # Clay, Perforated Iron, Brass, Porcelain, Olive Wood
      t.string :dimensions         # e.g. 28cm x 16cm
      t.text :cultural_significance # Deep cultural context for the Buna ceremony
      t.text :usage_instructions
      t.string :image_url

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
    add_index :products, :origin_zone
    add_index :products, :roast_profile
    add_index :products, :bean_format
    add_index :products, :price_kes
    add_index :products, :stock_quantity
    add_index :products, :is_active
    add_index :products, :is_featured
  end
end
