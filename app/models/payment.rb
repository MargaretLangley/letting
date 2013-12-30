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
    def clear_up
      each &:clear_up
    end
  end
  before_validation :clear_up
  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account_id, :amount, :on_date, presence: true

  # PaymentDecorator passes the source (payment) to the form
  # which means keeping human_ref - not central to payment
  # in this object.
  #
  attr_accessor :human_ref

  after_initialize do
    self.on_date = default_on_date if on_date.blank?
  end

  ####
  # If an account exists
  ###
  #
  def account_exists?
    account.present?
  end

  def prepare
    credits.push *account_prepare_credits
  end

  def clear_debt
    self.amount = outstanding
  end

  def clear_up
    credits.clear_up
  end

  ####
  # If there an outstanding debit? (in which case credits are generated)
  ####
  #
  def in_debt?
    credits.any?
  end

  def self.search date_string
    if date_string.present? && parse_date?(date_string)
      Payment.includes(account: [:property])
             .where(created_at: \
              date_to_datetime_range(Payment.parse_date date_string))
    else
      none
    end
  end

  private

  def account_prepare_credits
    account.prepare_credits
  end

  def self.date_to_datetime_range date
    date.to_datetime.beginning_of_day..date.to_datetime.end_of_day
  end

  def self.parse_date date_string
    DateTime.parse date_string
  end

  def self.parse_date? date_string
    Payment.parse_date date_string
    rescue
      false
  end

  def default_on_date
    Date.current
  end

  def outstanding
    credits.outstanding
  end
end
