class PlansController < ApplicationController
  include PlanGenerator
  skip_before_action :authenticate_shop!

  def new
  end

  def create
  end
end
