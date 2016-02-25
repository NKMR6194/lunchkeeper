class UsersController < ApplicationController
  skip_before_action :authenticate_shop!
  before_action :set_user

  def show
    @active_plan = Plan.find_by(user_id: @user.id, state: :contracting)
    @old_plans   = Plan.where(user_id: @user.id, state: :done).limit(10)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
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
