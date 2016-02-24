class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id
      t.integer :price
      t.datetime :start_at
      t.datetime :delivery_at
      t.timestamps null: false
    end
  end
end
