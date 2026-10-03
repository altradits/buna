class AddMissingSolidQueueTables < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:solid_queue_pauses)
      create_table :solid_queue_pauses do |t|
        t.string :queue_name, null: false, index: { unique: true }
        t.datetime :created_at, null: false
      end
    end

    unless table_exists?(:solid_queue_blocked_executions)
      create_table :solid_queue_blocked_executions do |t|
        t.references :job, index: { unique: true }, null: false, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
        t.string :queue_name, null: false
        t.integer :priority, default: 0, null: false
        t.string :concurrency_key, null: false
        t.datetime :expires_at, null: false

        t.datetime :created_at, null: false

        t.index [ :expires_at, :concurrency_key ], name: "index_solid_queue_blocked_executions_for_maintenance"
      end
    end

    unless table_exists?(:solid_queue_recurring_executions)
      create_table :solid_queue_recurring_executions do |t|
        t.references :job, index: { unique: true }, null: false, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
        t.string :task_key, null: false
        t.datetime :run_at, null: false
        t.datetime :created_at, null: false

        t.index [ :task_key, :run_at ], unique: true
      end
    end
  end
end
