def user_create! **args
  user = User.new args
  user.save!
end
