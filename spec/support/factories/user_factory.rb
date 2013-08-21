def user_factory args = {}
  user = User.new id: args[:id], email: args[:email], \
                  password: args[:password],
                  password_confirmation: args[:password_confirmation]
  user.save!
end