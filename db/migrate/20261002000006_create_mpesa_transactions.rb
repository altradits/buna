class CreateMpesaTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :mpesa_transactions do |t|
      t.references :order, foreign_key: true, null: true, index: true
      t.string :merchant_request_id, index: true
      t.string :checkout_request_id, index: true
      t.string :transaction_type, default: "CustomerPayBillOnline"
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :phone_number, null: false
      t.string :mpesa_receipt_number, index: true
      t.integer :result_code
      t.string :result_desc
      t.datetime :transaction_date
      t.string :status, default: "initiated", null: false # initiated, pending, success, failed, cancelled
      t.jsonb :raw_callback_payload, default: {}

      t.timestamps
    end

    add_index :mpesa_transactions, :status
    add_index :mpesa_transactions, [:checkout_request_id, :merchant_request_id]
  end
end
