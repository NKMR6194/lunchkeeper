json.array!(@users) do |user|
  json.extract! user, :id, :email, :crypted_password, :salt, :name, :phone, :address, :position_x, :position_y
  json.url user_url(user, format: :json)
end
