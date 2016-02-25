class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :shop_id
      t.integer :plan_id
      t.integer :menu_id
      t.datetime :delivery_at
      t.integer :state, default: 0, null: false, limit: 1

      t.timestamps null: false
    end
  end
end
