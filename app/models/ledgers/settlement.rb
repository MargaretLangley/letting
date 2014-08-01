####
#
# Settlement
#
# Settlement is how the ledgers system pays debits or spends credits.
#
# Debits and Credits are created, but they cannot be paid or spent until
# a settlement is generated. Settlements link a credit to a debit.
#
# If a charge_id has an outstanding debit and it receives a credit - a
# settlement is applied to the debit - the smallest of the amounts of debits
# or credits. Visa versa for unspent credit receiving a debit.
#
# When a credit has been spent or a debit paid it is ignored by the
# settlement system.
#
####
#
class Settlement < ActiveRecord::Base
  belongs_to :credit
  belongs_to :debit

  validates :credit_id, :debit_id, :amount, presence: true

  # resolving settlement with credits
  # The amount of the settlement depends on the value(s) of
  # unpaid credit.
  #
  # settle - the amount thatat has not been offset against.
  # offsets - unspent offsets (we assume it's for this charge)
  #
  def self.resolve settle, offsets
    offsets.each do |offsetable|
      settle -= pay = [settle, offsetable.outstanding].min
      break if pay.round(2) == 0.00
      yield offsetable, pay
    end
  end
end
