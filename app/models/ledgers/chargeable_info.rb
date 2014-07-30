####
#
# ChargeableInfo
#
#  Holds information to turn a charge into a debit
#
#  The debit generator needs to generate debits from charges.
#  It calls on account for due charges and in turn charge
#  generates a ChargeableInfo describing a charge that is due
#  in the queried date range.
#
#  Hashes use symbols as hash keys - faster and saves memory.
#  http://stackoverflow.com/questions/8189416/why-use-symbols-as-hash-keys-in-ruby
#
####
#
class ChargeableInfo
  include Equalizer.new(:account_id, :amount, :charge_id, :on_date)
  attr_reader :account_id, :charge_id, :on_date, :amount

  def self.from_charge(charge_id:, on_date:, amount:, account_id:)
    new charge_id:  charge_id,
        on_date:    on_date,
        amount:     amount,
        account_id: account_id
  end

  # instance_values is a rails object that returns instances
  # as hashes with keys as named strings .
  #
  def to_hash **overrides
    instance_values.symbolize_keys.merge overrides
  end

  private

  def initialize(charge_id:, on_date:, amount:, account_id:)
    @charge_id  = charge_id
    @on_date    = on_date
    @amount     = amount
    @account_id = account_id
  end
end
