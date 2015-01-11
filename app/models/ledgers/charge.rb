####
#
# A charge that is applied to a property's account.
#
# A charge represents the type, amount and, through due_ons, the date that
# a property should become due a charge.
#
# The code is part of the charge system in the accounts. Charges are
# associated with a property's account. When an operator decides they want to
# bill a group of properties. Charges are generated according to this
# information using the invoicing system. The information is passed, as a
# chargeable, to becomes a debit in the property's account.debits
#
####
#
class Charge < ActiveRecord::Base
  include PaymentTypeDefaults
  belongs_to :account
  has_many :credits, dependent: :destroy, inverse_of: :charge
  has_many :debits, dependent: :destroy, inverse_of: :charge
  belongs_to :cycle, class_name: 'Cycle',
                     foreign_key: 'cycle_id',
                     inverse_of: :charges
  delegate :monthly?, to: :cycle
  validates :charge_type, :cycle, presence: true
  validates :payment_type, inclusion: { in: PAYMENT_TYPE }
  validates :amount, price_bound: true
  validates :amount, numericality: { less_than: 100_000 }

  after_initialize :init

  def init
    self.start_date = Date.parse DateDefaults::MIN if start_date.blank?
    self.end_date = Date.parse DateDefaults::MAX if end_date.blank?
  end

  # billing_period - the date range that we generate charges for.
  # returns        - chargable_info array with data required to bill the
  #                  associated account. Empty array if nothing billed.
  def coming billing_period
    return [] if dormant
    cycle.between(billing_period).map do |matched_cycle|
      make_chargeable(matched_cycle)
    end.compact
  end

  def prepare
    # maybe should be calling prepare on charge structure
  end

  def clear_up_form
    mark_for_destruction unless edited?
  end

  def automatic_payment?
    payment_type == STANDING_ORDER
  end

  def to_s
    "charge: #{charge_type}, #{cycle}"
  end

  private

  def edited?
    !empty?
  end

  # Converts a Charge object into a Chargeable object.
  # matched_cycle - struct of date the charge becomes due, spot, and
  #                 the period it is billed for, period.
  # returns   - The information to bill, debit, the associated account.
  #
  def make_chargeable matched_cycle
    Chargeable.from_charge charge_id:  id,
                           at_time:    matched_cycle.spot,
                           amount:     amount,
                           account_id: account_id,
                           period:     matched_cycle.period
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?) &&
      start_date == Date.parse(DateDefaults::MIN) &&
      end_date == Date.parse(DateDefaults::MAX)
  end

  def ignored_attrs
    %w(id account_id start_date end_date created_at updated_at)
  end
end
