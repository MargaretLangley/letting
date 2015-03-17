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
  has_many :credits, inverse_of: :payment, dependent: :destroy do
    def clear_up
      each(&:clear_up)
    end

    def register_booking payment
      each { |credit| credit.register_booking(payment) }
    end
  end
  after_initialize :init
  before_validation :clear_up

  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account, :booked_at, presence: true
  validates :amount, price_bound: true

  def init
    self.amount = 0 if amount.blank?
    self.booked_at = Time.zone.now if booked_at.blank?
  end

  def account_exists?
    account.present?
  end

  def prepare
    return unless account_exists?
    credits.push(*account.make_credits)
  end

  # register_booking
  #
  # record the booked_at time.
  #   - form attributes come with booked_at as a date without a time.
  #     if the date is today we add the current time on.
  def register_booking
    return unless booked_at

    self.booked_at = ClockIn.new.recorded_as booked_time: booked_at.to_date,
                                             add_time: true
    credits.register_booking(self)
  end

  def self.date_range(range: '2013-01-01'..'2013-12-31')
    where(booked_at: range.first...range.last)
  end

  def self.by_booked_at_date
    order('DATE(booked_at) desc').group('DATE(booked_at)')
      .pluck('DATE(booked_at) as booked_on,'\
             ' count(amount) as payments_count, ' \
             ' sum(amount) as payment_sum')
  end

  # human_ref - the id of the account / property to return
  #
  def self.human_ref human_ref
    Payment.includes(account: [:property])
      .where(properties: { human_ref: human_ref })
  end

  include Searchable
  # Elasticsearch uses generates JSON document for payment index
  def as_indexed_json(_options = {})
    as_json(
      include: {
        account: { methods: [:human_ref, :holder, :address] }
      })
  end

  private

  def clear_up
    credits.clear_up
  end
end
