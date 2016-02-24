class ErrorsController < ApplicationController

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end

  def can_not_find

  end
end
