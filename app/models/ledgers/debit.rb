####
#
# Debit
#
# Why does this class exist?
#
# It represents an item of debit held under a property's account.
#
# How does it fit in to the larger system?
#
# Properties have charges which become due. The act of become due is to
# generate debits for a charge on a particular date - it then sits against
# the property's account. Credits made by tenants offset these debits.
#
# When a charge is being generated the generation system checks against when
# the debit became due to see if the property has already been charged against
# for this time period.
#
# Debits increase an accounts balance +.
#
####
#
class Debit < ActiveRecord::Base
  include Comparable
  belongs_to :account, inverse_of: :debits
  has_many :credits, through: :settlements
  has_many :settlements, dependent: :destroy
  belongs_to :charge, inverse_of: :debits
  belongs_to :debits_transaction, inverse_of: :debits

  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  validates :charge, :on_date, presence: true
  # custom validates - numericality did not think -99_000 > -100_000
  validates :amount, amount: true
  before_save :reconcile

  delegate :charge_type, to: :charge

  def outstanding
    amount - settled
  end

  def paid?
    amount.round(2) == settled.round(2)
  end

  # Value equality - not sure if that is what is required
  #
  def <=> other
    return nil unless other.is_a?(self.class)
    [charge_id, on_date, amount] <=>
      [other.charge_id, other.on_date, other.amount]
  end

  def to_debitable
    {
      charge_type: charge_type,
      date_due: on_date,
      period: period,
      amount: amount,
    }
  end

  # charge_id - the charge's being queried for unpaid debits.
  # returns unpaid debits for the charge_id
  #
  def self.available charge_id
    where(charge_id: charge_id).order(:on_date).reject(&:paid?)
  end

  private

  def settled
    settlements.pluck(:amount).inject(0, :+)
  end

  def reconcile
    Settlement.resolve(outstanding,
                       Credit.available(charge_id)) do |offset, pay|
      settlements.build(credit: offset, amount: pay)
    end
  end
end
