class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  private
  def not_authenticated
    redirect_to new_user_session_path, notice: "Please login first"
  end

  def shop_authorize
    if !Shop.find_by id: session[:shop_id]
      redirect_to new_shop_session_path, notice: "Please login first"
    end
  end

end
