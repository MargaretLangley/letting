# rubocop: disable Metrics/MethodLength

def user_create nickname: 'user',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password',
                 role: 'user'
  user = User.new nickname: nickname,
                  email: email,
                  password: password,
                  password_confirmation: password_confirmation,
                  role: role
  user.save!
  user
end
