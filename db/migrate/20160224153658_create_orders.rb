class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :shop_id
      t.integer :menu_id
      t.integer :state

      t.timestamps null: false
    end
  end
end
