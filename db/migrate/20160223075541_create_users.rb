class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :salt
      t.string :name
      t.string :phone
      t.text :address
      t.float :position_x
      t.float :position_y

      t.timestamps null: false
    end
  end
end
