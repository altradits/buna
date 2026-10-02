class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :amharic_name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :icon
      t.integer :sort_order, default: 0
      t.string :image_url

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :sort_order
  end
end
