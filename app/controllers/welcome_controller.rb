class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authenticate_shop!

  def index
    redirect_to plans_path if user_signed_in?
    redirect_to shop_path  if shop_signed_in?
  end
end
