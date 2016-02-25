class OrdersController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    @order = Order.find(params[:id])
    respond_to do |format|
      if @order.delivered!
        format.html { redirect_to shop_path, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
end
