####
#
# Payment
#
# When a payment is received from a tenant it is represented by the payment
# object on the database.
#
# Payments are a collection of credits which offset against debits.
#
####
#
class Payment < ActiveRecord::Base
  belongs_to :account, inverse_of: :payments
  has_many :credits, dependent: :destroy do
    def clear_up
      each(&:clear_up)
    end

    def negate
      each(&:negate)
    end
  end
  after_initialize :init
  before_validation :clear_up

  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account, :booked_on, presence: true
  validates :amount, amount: true

  def init
    self.amount = 0 if amount.blank?
    self.booked_on = DateTime.current if booked_on.blank?
  end

  def account_exists?
    account.present?
  end

  def negate
    self.amount *= -1
    credits.negate
    self
  end

  def prepare
    return unless account_exists?
    credits.push(*account.make_credits)
  end

  def clear_up
    if self.new_record?
      self.booked_on = ClockIn.new.recorded_as booked_time: booked_on,
                                               add_time: true
    end
    negate
    credits.clear_up
  end

  def self.date_range(range: '2013-01-01'..'2013-12-31')
    where(booked_on: range.first...range.last)
  end

  include Searchable
  # Elasticsearch uses generates JSON document for payment index
  def as_indexed_json(_options = {})
    as_json(
      include: {
        account: { methods: [:holder, :address] }
      })
  end
end
