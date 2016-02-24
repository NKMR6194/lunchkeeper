json.array!(@shops) do |shop|
  json.extract! shop, :id, :email, :password_digest, :name, :phone, :address, :pref, :city, :rang, :capability, :open_at, :close_at, :position_x, :position_y
  json.url shop_url(shop, format: :json)
end
