def user_factory args = {}
  #user = User.new user_attributes args
  user = User.new args
  user.save!
end