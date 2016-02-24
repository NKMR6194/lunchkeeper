class WelcomeController < ApplicationController
  skip_before_filter :require_login, only: [:index]

  def index
    redirect_to plans_path if logged_in?
  end
end
