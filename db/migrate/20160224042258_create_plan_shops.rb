class CreatePlanShops < ActiveRecord::Migration
  def change
    create_table :plan_shops do |t|
      t.integer :shop_id
      t.integer :plan_id
      t.timestamps null: false
    end
  end
end
