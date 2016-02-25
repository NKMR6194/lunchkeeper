class ShopsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @shop         = Shop.find(params[:id])
    @today_orders = Order.joins(:user, :menu).where(["delivery_at >= ? and shop_id = ?", Time.zone.now.beginning_of_day, @shop.id])
  end
end
