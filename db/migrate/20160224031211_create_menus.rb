class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :shop_id
      t.string :name
      t.integer :price
      t.string :image_url
      t.timestamps null: false
    end
  end
end
