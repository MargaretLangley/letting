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
  accepts_nested_attributes_for :credits, allow_destroy: true
  attr_accessor :human_id

  validates :account_id, presence: true

  def present?
    account_id.present?
  end

  def debtless?
    credits.empty?
  end

  def prepare_for_form
    account && account.unpaid_debts.each do |debt|
      credits.build debt: debt
    end
  end

end
