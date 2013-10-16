class Payment < ActiveRecord::Base
  belongs_to :account
  has_many :credits

  validates :account_id, presence: true
end
