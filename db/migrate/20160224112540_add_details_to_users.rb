class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :pref, :string
    add_column :users, :city, :string
    add_column :users, :address, :string
  end
end
