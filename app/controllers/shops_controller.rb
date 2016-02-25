class ShopsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @shop         = current_shop
    @today_orders = Order.joins(:user).where(["delivery_at >= ? and shop_id = ?", Time.zone.now.beginning_of_day, @shop.id]).preload(:user, :menu)
  end
end
