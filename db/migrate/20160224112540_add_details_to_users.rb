class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :pref, :string
    add_column :users, :city, :string
    add_column :users, :address, :text
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
