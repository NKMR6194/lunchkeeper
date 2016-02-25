class PlansController < ApplicationController
  include PlanGenerator
  skip_before_action :authenticate_shop!

  def index
  end

  def show
  end
end
