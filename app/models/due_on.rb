class DueOn < ActiveRecord::Base
  belongs_to :charge
  validates :day, :month, presence: true
  validates :day, numericality: { only_integer: true, greater_than: 0, less_than: 32 }
  validates :month, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
end
