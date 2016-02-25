class UsersController < ApplicationController
  skip_before_action :authenticate_shop!
  before_action :set_user

  include Position

  def show
    @active_plan = Plan.find_by(user_id: @user.id, state: Plan.states[:contracting])
    @old_plans   = Plan.where(user_id: @user.id, state: Plan.states[:done]).limit(10)
  end

  def edit
  end

  def update
    respond_to do |format|
      address = user_params[:pref] + user_params[:city] + user_params[:address]
      lat, lot = find_position(address)
      if @user.update(user_params) && @user.update(latitude: lat, longitude: lot)
        format.html { redirect_to user_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :phone, :pref, :city, :address)
  end
end
