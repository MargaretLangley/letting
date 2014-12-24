###################
#
# SnapshotMaker
#
# Takes a snapshot of the state of an account on transaction.
# The balance and the debits created for that instance.
#
# Used by Account class to wrap (see: debit_maker.gliffy)
#
class SnapshotMaker
  attr_reader :account, :debit_period, :snapshot
  def initialize account:, debit_period:, snapshot: Snapshot.new
    @account = account
    @debit_period = debit_period
    @snapshot = snapshot
  end

  def debits?
    mold
    snapshot.debits?
  end

  def invoice(*)
    mold
    snapshot
  end

  private

  def mold
    snapshot
      .debited debits: account.exclusive(query_debits: make_debits)
    self
  end

  def make_debits
    account.debits_coming(debit_period)
  end
end
