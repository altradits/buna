# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_10_03_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "amharic_name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "icon"
    t.integer "sort_order", default: 0
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
    t.index ["sort_order"], name: "index_categories_on_sort_order"
  end

  create_table "mpesa_transactions", force: :cascade do |t|
    t.bigint "order_id"
    t.string "merchant_request_id"
    t.string "checkout_request_id"
    t.string "transaction_type", default: "CustomerPayBillOnline"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "phone_number", null: false
    t.string "mpesa_receipt_number"
    t.integer "result_code"
    t.string "result_desc"
    t.datetime "transaction_date"
    t.string "status", default: "initiated", null: false
    t.json "raw_callback_payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkout_request_id", "merchant_request_id"], name: "idx_on_checkout_request_id_merchant_request_id_71936513ba"
    t.index ["checkout_request_id"], name: "index_mpesa_transactions_on_checkout_request_id"
    t.index ["merchant_request_id"], name: "index_mpesa_transactions_on_merchant_request_id"
    t.index ["mpesa_receipt_number"], name: "index_mpesa_transactions_on_mpesa_receipt_number"
    t.index ["order_id"], name: "index_mpesa_transactions_on_order_id"
    t.index ["status"], name: "index_mpesa_transactions_on_status"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "unit_price_kes", precision: 10, scale: 2, null: false
    t.decimal "unit_price_etb", precision: 10, scale: 2, null: false
    t.decimal "total_price_kes", precision: 10, scale: 2, null: false
    t.decimal "total_price_etb", precision: 10, scale: 2, null: false
    t.string "selected_format"
    t.string "selected_roast"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "order_number", null: false
    t.string "status", default: "pending_payment", null: false
    t.string "currency_used", default: "KES", null: false
    t.decimal "exchange_rate_applied", precision: 10, scale: 4, default: "0.88"
    t.decimal "subtotal_kes", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "subtotal_etb", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shipping_fee_kes", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shipping_fee_etb", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_kes", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_etb", precision: 10, scale: 2, default: "0.0", null: false
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.string "customer_phone", null: false
    t.text "delivery_address", null: false
    t.string "delivery_city", default: "Nairobi", null: false
    t.string "delivery_county", default: "Nairobi"
    t.string "postal_code"
    t.string "origin_hub", default: "Addis Ababa Bole Central Hub"
    t.string "border_transit_hub", default: "Moyale One-Stop Border Post"
    t.string "destination_hub", default: "Nairobi Distribution Hub"
    t.string "courier_provider", default: "Fargo Courier East Africa"
    t.string "tracking_number"
    t.text "order_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_phone"], name: "index_orders_on_customer_phone"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["tracking_number"], name: "index_orders_on_tracking_number"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name", null: false
    t.string "amharic_name"
    t.string "slug", null: false
    t.string "sku", null: false
    t.string "short_description"
    t.text "description"
    t.decimal "price_kes", precision: 10, scale: 2, null: false
    t.decimal "price_etb", precision: 10, scale: 2, null: false
    t.integer "stock_quantity", default: 0, null: false
    t.integer "weight_grams", default: 500
    t.boolean "is_featured", default: false
    t.boolean "is_active", default: true
    t.string "origin_zone"
    t.string "roast_profile"
    t.string "bean_format"
    t.string "processing_method"
    t.string "elevation"
    t.text "tasting_notes"
    t.string "material"
    t.string "dimensions"
    t.text "cultural_significance"
    t.text "usage_instructions"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bean_format"], name: "index_products_on_bean_format"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["is_active"], name: "index_products_on_is_active"
    t.index ["is_featured"], name: "index_products_on_is_featured"
    t.index ["origin_zone"], name: "index_products_on_origin_zone"
    t.index ["price_kes"], name: "index_products_on_price_kes"
    t.index ["roast_profile"], name: "index_products_on_roast_profile"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["stock_quantity"], name: "index_products_on_stock_quantity"
  end

  create_table "shipping_shipments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "tracking_number", null: false
    t.string "courier_provider", default: "Fargo Courier East Africa", null: false
    t.string "service_level", default: "CrossBorderExpress"
    t.string "origin_hub", default: "Addis Ababa Bole Central Hub"
    t.string "border_station", default: "Moyale One-Stop Border Post (OSBP)"
    t.string "destination_hub", default: "Nairobi Industrial Area Logistics Center"
    t.string "current_checkpoint"
    t.string "status", default: "manifested", null: false
    t.datetime "dispatched_at"
    t.datetime "estimated_delivery_at"
    t.datetime "delivered_at"
    t.json "tracking_events"
    t.text "consignment_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipping_shipments_on_order_id"
    t.index ["status"], name: "index_shipping_shipments_on_status"
    t.index ["tracking_number"], name: "index_shipping_shipments_on_tracking_number", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_on_queue_name_and_finished_at"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_on_scheduled_at_and_finished_at"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "full_name"
    t.string "phone_number"
    t.string "role", default: "customer", null: false
    t.string "preferred_currency", default: "KES"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city", default: "Nairobi"
    t.string "county", default: "Nairobi"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "mpesa_transactions", "orders"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "shipping_shipments", "orders"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
