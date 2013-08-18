class BeDue < ActiveRecord::Base
  belongs_to :charge
  validates :day, :charge_id, :month, presence: true
  validates :day, numericality: { only_integer: true, greater_than: 0, less_than: 32 }
  validates :month, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
end
