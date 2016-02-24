class PlanShop < ActiveRecord::Base
  belongs_to :shop
  belongs_to :plan
end
