class PlansController < ApplicationController
  include PlanGenerator
  include SearchNeighborShops
  skip_before_action :authenticate_shop!

  def new
    @isContracting = false
    if Plan.contracting.where(user_id: current_user.id).present?
      @isContracting = true
      @plans = []
    else
      @delivery_at = params[:plan][:delivery_at] if params[:plan]
      @delivery_at ||= "11:00"
      shops = search_neighbor_shops current_user
      @plans = plan_generate Shop.all, @delivery_at
    end
  end

  def create
    plan = current_user.plan.build(params_plan)
    params_orders.each_with_index do |order, index|
      plan.orders.build({
        user_id: current_user.id,
        menu_id: order[:menu_id],
        shop_id: order[:shop_id],
        delivery_at: plan.start_at.strftime("%Y/%m/%d ").advance(days: index) + plan.delivery_at
      })
    end
    respond_to do |format|
      if plan.save
        format.html { redirect_to user_path, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def params_plan
    params.require(:plan).permit(:price, :start_at, :end_at, :delivery_at)
  end

  def params_orders
    params.require(:plan).permit(:orders)
  end
end
