###################
#
# DebitMaker
#
# Makes debits for an account given a period to charge over.
#
# Used by Account class to wrap (see: debit_maker.gliffy)
#
class DebitMaker
  attr_reader :account, :debit_period
  def initialize(account:, debit_period:)
    @account = account
    @debit_period = debit_period
  end

  def mold
    account.exclusive(query_debits: make_debits)
  end

  def make_debits?
    mold.size.nonzero? ? true : false
  end

  def sum
    make_debits.map(&:amount).inject(0, :+)
  end

  def invoice(*)
    balance_before_billing = account.balance to_date: debit_period.first - 1.day
    {
      arrears: balance_before_billing,
      total_arrears: balance_before_billing + sum,
      debits: mold,
    }
  end

  private

  def make_debits
    account.charges.map do |charge|
      charge.coming(debit_period).map do |chargeable|
        Debit.new(chargeable.to_hash)
      end
    end.flatten
  end
end
