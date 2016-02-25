class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  enum state: {preparing: 0, delivered: 1}
end
