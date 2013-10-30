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
    def outstanding
      map { |credit| credit.outstanding }.sum
    end

    def clear_up_after_form
      each { |charge| charge.clear_up_after_form }
    end

  end
  accepts_nested_attributes_for :credits, allow_destroy: true
  before_validation :clear_up_after_form

  attr_accessor :human_ref

  validates :account_id, :on_date, presence: true

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
    if account
      account.prepare_for_form
      account.credits_for_unpaid_debits.each { |credit| credits << credit }
    end
    self.amount = outstanding if amount.blank?
  end

  def clear_up_after_form
    credits.clear_up_after_form
  end

  def self.search date_string
    if date_string.present? && parse_date?(date_string)
      Payment.includes(account: [:property])
             .where(created_at: date_to_datetime_range(Date.parse date_string))
    else
      none
    end
  end

  private

  def self.date_to_datetime_range date
    date.to_datetime.beginning_of_day..date.to_datetime.end_of_day
  end

  def self.parse_date? date_string
    Date.parse date_string
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
