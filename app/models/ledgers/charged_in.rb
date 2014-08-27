class ChargedIn < ActiveRecord::Base
  has_many :charges, inverse_of: :charged_in
  validates :name, presence: true
end
