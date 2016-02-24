class CreatePlanMenus < ActiveRecord::Migration
  def change
    create_table :plan_menus do |t|
      t.integer :menu_id
      t.integer :plan_id
      t.integer :shop_id
      t.integer :state
      t.datetime :delivery_at
      t.timestamps null: false
    end
  end
end
