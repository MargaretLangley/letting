def user_factory args = {}
  user = User.new id: args[:id], email: args[:email], \
                  password: args[:password],
                  password_confirmation: args[:password_confirmation],
                  admin: args[:admin]
  user.save!
end