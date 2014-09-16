# rubocop: disable Metrics/MethodLength

def user_create nickname: 'user',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password',
                 admin: false
  user = User.new nickname: nickname,
                  email: email,
                  password: password,
                  password_confirmation: password_confirmation,
                  admin: admin
  user.save!
  user
end
