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
      each(&:clear_up)
    end

    def reverse
      each(&:reverse)
    end
  end
  before_validation :clear_up

  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account_id, :amount, :on_date, presence: true

  after_initialize do
    self.on_date = Date.current if on_date.blank?
  end

  def account_exists?
    account.present?
  end

  def reverse_credits
    credits.reverse
  end

  def prepare
    return unless account_exists?
    credits.push(*account.prepare_credits)
  end

  delegate :clear_up, to: :credits

  def self.payments_on date
    date ||= Date.current.to_s
    return Payment.none unless SearchDate.new(date).valid_date?
    Payment.includes(account: [:property])
           .where(created_at: SearchDate.new(date).day_range)
  end
end
