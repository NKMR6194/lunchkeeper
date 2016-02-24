class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :phone
      t.text :address
      t.string :pref
      t.string :city
      t.integer :range
      t.integer :capability
      t.datetime :open_at
      t.datetime :close_at

      t.timestamps null: false
    end
  end
end
