class ShopSessionsController < ApplicationController
  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new
    record = Shop.find_by email: params[:shop][:email]
    if record == nil then
      @shop.errors.add "email","this email is wrong"
      render :action => 'new'
    else
      if !record.authenticate params[:shop][:password] then
        @shop.errors.add "password","this password is wrong"
        render :action => 'new'
      else
        @shop = record
        session[:shop_id] = @shop.id
        redirect_to shop_path(@shop.id), notice: 'Login successful'
      end
    end
  end

  def destroy
    session[:shop_id] = nil
    flash.clear
    redirect_to new_shop_session_path
  end

end
