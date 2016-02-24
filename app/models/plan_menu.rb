class PlanMenu < ActiveRecord::Base
  belongs_to :plan
  belongs_to :menu
  enum state: {in_process: 0, dispatched: 1, canceled: 2}

  def delivery_range
    begin_time = delivery_at.strftime("%H:%M")
    end_at = delivery_at + 1.hour
    end_time = end_at.strftime("%H:%M")
    "#{begin_time} 〜 #{end_time}"
  end
end
