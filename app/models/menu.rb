class Menu < ActiveRecord::Base
  belongs_to :shop
  has_many :plan_menus
  has_many :order
end
