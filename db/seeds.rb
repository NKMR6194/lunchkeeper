require "rexml/document"

i = 0
user = User.new(email: "#{i}@mail.com", password: "password")
i += 1
user.assign_attributes({
  name: "山田太郎",
  phone: "000-0000-000",
  pref: "東京都",
  city: "千代田区",
  address: "丸の内1-9-2"
})
user.save!

f = File.open(File.join(Rails.root, "db", "shops.xml"))
shops = REXML::Document.new(f)

shops.elements.each("Results/Shop") do |s|
  shop = Shop.new(email: "#{i}@mail.com", password: "password")
  i += 1
  full_address = s.elements["ShopAddress"].text
  pref, city, address = /^(.+?[都道府県])(.+?[市区町村])(.*)$/.match(full_address)
  shop.assign_attributes({
    name: s.elements["ShopName"].text,
    phone: "000-0000-000",
    pref: pref,
    city: city,
    address: address,
    open_at: "#{Random.new.rand(6) + 6}:00",
    close_at: "#{Random.new.rand(7) + 17}:00"
  })
  # 店に10品の食品、店の価格グレードを4種類想定
  # 0. 低価格店 200-700円
  # 1. 中価格店 600-1100円
  # 2. 高価格店 1000-1500円
  # 3. 全てを含んだ店 200-1500円
  shop_grade = Random.new.rand(4)
  menus = []
  10.times do |j|
    case shop_grade
    when 0
      name = "低価格セット #{j}"
      price = (Random.new.rand(51) + 20) * 10
    when 1
      name = "中価格セット #{j}"
      price = (Random.new.rand(51) + 60) * 10
    when 2
      name = "高価格セット #{j}"
      price = (Random.new.rand(51) + 100) * 10
    when 3
      name = "セット #{j}"
      price = (Random.new.rand(131) + 20) * 10
    end
    menu = {
      name: name,
      price: price,
      image_url: "foods/#{Random.new.rand(4)}.jpg"
    }
    menus.push(menu)
  end
  shop.menus.build menus
  shop.save!
end

10.times do |j|
  delivery_at =  "#{Random.new.rand(4) + 10}:00"
  start_at = Time.zone.now
  plan = Plan.new({
    user_id: user.id,
    start_at: start_at.beginning_of_day,
    end_at: start_at.advance(days: 5).beginning_of_day,
    delivery_at: delivery_at
  })
  plan.done! unless j == 0
  price = 0
  5.times do |k|
    menu = Menu.find(Menu.pluck(:id).sample)
    plan.orders.build({
      user_id: user.id,
      menu_id: menu.id,
      shop_id: menu.shop.id,
      delivery_at: Time.zone.parse("#{(start_at + k.days).strftime("%Y/%m/%d")} #{delivery_at}")
    })
    price += menu.price
  end
  plan.assign_attributes(price: price)
  plan.save!
end
