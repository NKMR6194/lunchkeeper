class Shop < ActiveRecord::Base
	has_secure_password
	has_many :menus
	has_many :plan_shops
end
