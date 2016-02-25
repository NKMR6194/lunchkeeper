class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id
      t.integer :price
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :delivery_at
      t.integer :state, default: 0, null: false, limit: 1
      t.timestamps null: false
    end
  end
end
