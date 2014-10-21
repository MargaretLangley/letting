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
  belongs_to :account
  belongs_to :charged_in, inverse_of: :charges
  belongs_to :cycle, inverse_of: :charges
  # charged_in_name
  delegate :name, to: :charged_in, prefix: true
  delegate :monthly?, to: :cycle
  validates :charge_type, :cycle, :charged_in, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than: 100_000 }
  has_many :credits, dependent: :destroy, inverse_of: :charge
  has_many :debits, dependent: :destroy, inverse_of: :charge do
    def created_on? on_date
      self.any? do |debit|
        debit.on_date == on_date
      end
    end
  end

  after_initialize do
    self.start_date = Date.parse MIN_DATE if start_date.blank?
    self.end_date = Date.parse MAX_DATE if end_date.blank?
  end

  # billing_period - the date range that we generate charges for.
  # returns        - chargable_info array with data required to bill the
  #                  associated account. Empty array if nothing billed.
  def coming billing_period
    return [] if dormant
    allowed_dates(billing_period).map do |billed_on|
      make_chargeable(billed_on)
    end.compact
  end

  def bill_period(billed_on:)
    repeated_dates = cycle.due_ons.map do |due_on|
      Date.new billed_on.year, due_on.month, due_on.day
    end
    # Anything except mid-term take the charge cycle's due_ons and
    # apply either advance or arrears.
    # For mid-term I need to load other charge_cycle due_ons
    # I need completely different due_ons for the mid-term
    RangeCycle.for(name: charged_in_name, dates: repeated_dates)
              .duration within: billed_on
  end

  def prepare
    # maybe should be calling prepare on charge structure
  end

  def clear_up_form
    mark_for_destruction unless edited?
  end

  def to_s
    "charge: #{charge_type}, #{charged_in}, #{cycle}"
  end

  private

  def edited?
    !empty?
  end

  def allowed_dates billing_period
    cycle.between(billing_period) & charge_active_epoch.to_a
  end

  # The years, dates, a charge is active
  def charge_active_epoch
    (start_date..end_date)
  end

  # Converts a Charge object into a Chargeable object.
  # billed_on - the date the charge becomes due and is billed.
  # returns   - The information to bill, debit, the associated account.
  #
  def make_chargeable billed_on
    Chargeable.from_charge charge_id:  id,
                           on_date:    billed_on,
                           amount:     amount,
                           account_id: account_id,
                           period: bill_period(billed_on: billed_on)
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?) &&
    start_date == Date.parse(MIN_DATE) &&
    end_date == Date.parse(MAX_DATE)
  end

  def ignored_attrs
    %w(id account_id start_date end_date created_at updated_at)
  end
end
