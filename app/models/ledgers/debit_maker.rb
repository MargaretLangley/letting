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

  def debits?
    mold
    @debits_transaction.debits?
  end

  def invoice(*)
    mold
    debits_transaction
  end

  private

  def mold
    debits_transaction
      .debited debits: account.exclusive(query_debits: make_debits)
    self
  end

  def make_debits
    account.debits_coming(debit_period)
  end
end
