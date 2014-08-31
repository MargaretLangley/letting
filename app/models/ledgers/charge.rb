####
#
# A charge that is applied to a property's account.
#
# A charge represents the type, amount and, through due_ons, the date that
# a property should become due a charge.
#
# The code is part of the charge system in the accounts. Charges are
# associated with a propertie's account. When an operator decides they want to
# bill a group of properties. Charges are generated according to this
# information using the debit generator. The information is passed, as a
# chargeable, to becomes a debit in the propertie's account.debits
#
####
#
class Charge < ActiveRecord::Base
  belongs_to :account
  # charged_in_name
  belongs_to :charged_in, inverse_of: :charges
  belongs_to :charge_cycle, inverse_of: :charges
  delegate :name, to: :charged_in, prefix: true
  validates :charge_type, :charge_cycle, :charged_in, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than: 100_000 }
  has_many :debits, dependent: :destroy do
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

  # date_range - the date range that we can generate charges for.
  # returns - array of objects with enough information to charge the
  #           associated account
  def next_chargeable date_range
    return [] if dormant
    allowed_due_dates(date_range).map do |my_date|
      chargeable_info(my_date) unless debits.created_on? my_date
    end.compact
  end

  def prepare
    # maybe should be calling prepare on charge structure
  end

  def clear_up_form
    mark_for_destruction unless edited?
  end

  private

  def edited?
    !empty?
  end

  def allowed_due_dates date_range
    charge_cycle.due_between?(date_range) & (start_date..end_date).to_a
  end

  # Converts a Charge object into a ChargeableInfo object.
  # date - the date we are are creating the charge on. Should match
  #        a date a charge becomes due.
  # returns The information to create a charge for the associated account_id
  #
  def chargeable_info date
    ChargeableInfo
      .from_charge charge_id:  id,
                   on_date:    date,
                   amount:     amount,
                   account_id: account_id
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
