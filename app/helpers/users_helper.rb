module UsersHelper
  # 経度
  KM_PER_LAT = 91.18758845251963
  # 緯度
  KM_PER_LOT = 110.94625761306844

  def search_shops(user)
    shops = Shop.where(pref: user.pref, city: user.city)
    shops.select do |shop|
      x_diff = (shop.position_x - user.position_x) * KM_PER_LAT
      y_diff = (shop.position_y - user.position_y) * KM_PER_LOT
      shop.range >= Math.sqrt(x_diff * x_diff + y_diff * y_diff)
    end
  end
end
