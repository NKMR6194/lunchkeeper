class PlanMenu < ActiveRecord::Base
  belongs_to :plan
  belongs_to :menu
  enum state: {in_process: 0, dispatched: 1, canceled: 2}
end
