###################
#
# DebitMaker
#
# Makes debits for an account given a period to charge over.
#
# Used by Account class to wrap (see: debit_maker.gliffy)
#
class DebitMaker
  attr_reader :account, :debit_period, :debits_transaction
  def initialize account:,
                 debit_period:,
                 debits_transaction: DebitsTransaction.new
    @account = account
    @debit_period = debit_period
    @debits_transaction = debits_transaction
  end

  def mold
    debits_transaction
      .debited debits: account.exclusive(query_debits: make_debits)
    self
  end

  def make? to_date: Time.zone.today
    balance_on(to_date: to_date) + debits_transaction.sum > 0
  end

  def invoice(*)
    debits_transaction
  end

  private

  def balance_on(to_date:)
    account.balance to_date: to_date
  end

  def make_debits
    account.debits_coming(debit_period)
  end
end
