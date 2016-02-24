class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :plan_menus
  has_many :plan_shops
end
