def user_factory args = {}
  user = User.new args
  user.save!
end