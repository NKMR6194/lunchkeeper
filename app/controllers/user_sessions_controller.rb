class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]
  def new
    @user = User.new
  end
 
  def create
    if @user = login(params[:email], params[:password],false)
      redirect_to edit_user_path(@user.id), notice: 'Login successful'
    else
      redirect_to login_path, notice: 'Login failed'
    end
  end
 
  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end
