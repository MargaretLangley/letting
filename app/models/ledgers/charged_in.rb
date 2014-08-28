class ChargedIn < ActiveRecord::Base
  has_many :charges, inverse_of: :charged_in

  has_many :charge_cycles, through: :cycle_charged_ins
  has_many :cycle_charged_ins, dependent: :destroy
  validates :name, presence: true
end
