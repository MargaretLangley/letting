####
#
# Payment
#
# When a payment is recieved from a tenant it is represented by the payment
# object on the database.
#
# Payments are a collection of credits which offset against debits.
#
####
#
class Payment < ActiveRecord::Base
  belongs_to :account
  has_many :credits, dependent: :destroy do
    def default_amount
      map { |credit| credit.default_amount }.sum
    end

    def prepare debit, account_id
      build debit: debit, account_id: account_id
    end
  end
  accepts_nested_attributes_for :credits, allow_destroy: true
  attr_accessor :human_id

  validates :account_id, presence: true

  after_initialize do |debit_generator|
    self.on_date = default_on_date if on_date.blank?
  end

  def present?
    account_id.present?
  end

  def required?
    credits.any?
  end

  def prepare_for_form
    account && account.unpaid_debits.each do |debit|
      credits.prepare debit, account_id
    end
    self.amount = default_amount if amount.blank?
  end

  private

  def default_on_date
    Date.current
  end

  def default_amount
    credits.default_amount
  end

end
