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

  def debits?
    @debits_transaction.debits?
  end

  def invoice(*)
    debits_transaction
  end

  private

  def make_debits
    account.debits_coming(debit_period)
  end
end
