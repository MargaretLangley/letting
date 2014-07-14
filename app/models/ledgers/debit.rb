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
####
#
class Debit < ActiveRecord::Base
  belongs_to :account
  belongs_to :debit_generator
  has_many :credits, through: :settlements
  has_many :settlements, dependent: :destroy
  belongs_to :charge

  validates :charge_id, :on_date, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than: 100_000 }
  before_save :reconcile

  def charge_type
    charge.charge_type
  end

  def outstanding
    amount - settled
  end

  def paid?
    amount.round(2) == settled.round(2)
  end

  def == other
    charge_id == other.charge_id &&
    on_date == other.on_date &&
    amount == other.amount
  end

  private

  def self.available charge_id
    where(charge_id: charge_id).order(:on_date).reject(&:paid?)
  end

  def settled
    settlements.pluck(:amount).inject(0, :+)
  end

  def reconcile
    Settlement.resolve_debit self, Credit.available(charge_id)
  end
end
