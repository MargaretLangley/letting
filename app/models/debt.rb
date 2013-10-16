####
#
# Debt
#
# Why does this class exist?
#
# It represents an item of debt held under a property's account.
#
# How does it fit in to the larger system?
#
# Properties have charges which become due. The act of become due is to
# generate debts for a charge on a particular date - it then sits against
# the property's account. Credits made by tenants offset these debts.
#
# When a charge is being generated the generation system checks against when
# the debt became due to see if the property has already been charged against
# for this time period.
#
####
#
class Debt < ActiveRecord::Base
  belongs_to :account
  belongs_to :debt_generator
  has_many :credits
  belongs_to :charge

  validates :charge_id, :on_date, presence: true
  validates :amount, amount: true

  def paid
    credits.pluck(:amount).inject(0, :+)
  end

  def paid?
    paid == amount
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

end
