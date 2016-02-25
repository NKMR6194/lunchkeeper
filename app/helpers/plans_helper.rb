module PlansHelper
  def contract_period plan
    "#{plan.start_at.strftime('%Y/%m/%d')} 〜 #{plan.end_at.strftime('%Y/%m/%d')}"
  end

  def contract_days plan
    ((plan.end_at - plan.start_at) / 1.day).to_i
  end

  def delivery_time plan
    "#{plan.delivery_at.strftime('%H:%M')} 〜 #{plan.delivery_at.advance(hours: 1).strftime('%H:%M')}"
  end
end
