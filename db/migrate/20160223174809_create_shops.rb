class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :email
      t.string :password_digest, null: false
      t.string :name
      t.string :phone
      t.text :address
      t.string :pref
      t.string :city
      t.integer :rang
      t.integer :capability
      t.datetime :open_at
      t.datetime :close_at
      t.float :position_x
      t.float :position_y

      t.timestamps null: false
    end
  end
end
