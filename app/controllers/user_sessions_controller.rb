class UserSessionsController < ApplicationController

  before_filter :require_login, only: [:destroy]

  def new
    @user = User.new
  end
 
  def create
    @user = User.new
    record = User.find_by email: params[:user][:email]
    if record == nil then
      @user.errors.add "email","this email is wrong"
      render :action => 'new'
    else
      if !record = login(params[:user][:email], params[:user][:password]) then
        @user.errors.add "password","this password is wrong"
        render :action => 'new'
      else
        @user = record
        redirect_to user_path(@user.id), notice: 'Login successful'
      end
    end
  end
 
  def destroy
    logout
    flash.clear
    redirect_to welcome_path
  end

  def welcome
  end
end
