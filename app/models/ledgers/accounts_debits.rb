###################
#
# AccountsDebits
#
# Ideally this should be an SQL statement. However, the due dates are held as
# month, day combinations which makes doing SQL queries tricky.
#
#
class AccountsDebits
  attr_reader :property_range, :debit_period, :list
  def initialize(property_range:, debit_period:)
    @property_range = property_range
    @debit_period = debit_period
  end

  def make_list
    make
    self
  end

  def list
    @account_debits.group_by do |account_debit|
      [account_debit.date_due, account_debit.charge_type]
    end
  end

  private

  def accounts
    Account.between?(property_range)
  end

  def make
    @account_debits = []
    accounts.each do |account|
      @account_debits << make_account_debits(account)
    end
    @account_debits.flatten!
  end

  def make_account_debits account
    account.debits_coming(debit_period).map do |debit|
      AccountDebit.new(date_due: debit.on_date.to_date,
                       charge_type: debit.charge_type,
                       property_ref: account.property.human_ref,
                       amount: debit.amount)
    end
  end
end
