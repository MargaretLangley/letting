####
#
# Payment
#
# When a payment is recieved from a tenant it is represented by the payment
# object on the database.
#
# Payments are a collection of credits which offset against debts.
#
####
#
class Payment < ActiveRecord::Base
  belongs_to :account
  has_many :credits
  attr_accessor :human_id

  validates :account_id, presence: true

  def present?
    account_id.present?
  end

  def self.from_human_id
    # id = Account.from_human_id human_id
    Payment.new account_id: 1
  end
end
