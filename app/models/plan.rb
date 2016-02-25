class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  has_many :plan_shops
  enum state: {contracting: 0, done: 1}
end
