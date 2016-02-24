class ChangeForShop < ActiveRecord::Migration
  def change
    rename_column :shops, :range, :range
  end
end
