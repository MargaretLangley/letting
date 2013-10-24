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
  has_many :credits, inverse_of: :debit
  belongs_to :charge

  validates :charge_id, :on_date, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than: 100000 }

  def paid?
    paid == amount
  end

  def outstanding
    amount - paid
  end

  def already_charged? other
    charge_id == other.charge_id &&
    on_date == other.on_date
  end

  def == other
    charge_id == other.charge_id &&
    on_date == other.on_date &&
    amount == other.amount
  end

  private

  def paid
    credits.pluck(:amount).inject(0, :+)
  end
end
