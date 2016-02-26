module ShopsHelper
  def operation_time shop
    "#{shop.open_at.strftime("%H:%M")} 〜 #{shop.close_at.strftime("%H:%M")}"
  end

  def shop_sample shops
    text = shops[0..2].map{ |s| s.name }.join("、")
    text << " 他" if shops.size > 3
    text << " 合計#{shops.size}店"
  end
end
