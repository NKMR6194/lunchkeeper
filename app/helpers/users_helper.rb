module UsersHelper
  def full_address user
    user.pref + user.city + user.address
  end
end
