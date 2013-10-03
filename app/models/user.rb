class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true,
                    format: { with: /\A.*@.*\z/ },
                    uniqueness: true
  validates :password_digest, presence: true
  validates :password, presence: true, on: :create
end
