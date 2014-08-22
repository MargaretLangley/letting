class ChargedIn < ActiveRecord::Base
  has_one :charge_structure, inverse_of: :charged_in
  validates :name, presence: true
end
