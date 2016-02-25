class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :plan
  belongs_to :shop
  enum state: {preparing: 0, delivered: 1}

  after_update do
    if self == plan.orders.max { |o| o.delivery_at.to_i }
      self.plan.done!
    end
  end
end
