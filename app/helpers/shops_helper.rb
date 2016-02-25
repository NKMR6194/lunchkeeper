module ShopsHelper
  def operation_time shop
    "#{shop.open_at.strftime("%H:%M")} 〜 #{shop.close_at.strftime("%H:%M")}"
  end
end
