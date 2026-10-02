class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # User Profile & Regional Checkout Fields
      t.string :full_name
      t.string :phone_number
      t.string :role, default: "customer", null: false # customer, admin, logistics_manager
      t.string :preferred_currency, default: "KES"

      # Default Address in Kenya
      t.string :address_line1
      t.string :address_line2
      t.string :city, default: "Nairobi"
      t.string :county, default: "Nairobi"
      t.string :postal_code

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :phone_number
    add_index :users, :role
  end
end
