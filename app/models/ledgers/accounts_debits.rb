###################
#
# AccountsDebits
#
# Ideally this should be an SQL statement. However, the due dates are held as
# month, day combinations which makes doing SQL queries tricky.
#
# rubocop: disable Style/TrivialAccessors
#
class AccountsDebits
  attr_reader :property_range, :debit_period
  def initialize(property_range:, debit_period:)
    @property_range = property_range
    @debit_period = debit_period
  end

  def make_list
    make
    self
  end

  def list
    @account_debits
  end

  private

  def accounts
    Account.between?(property_range)
  end

  def make
    @account_debits = Hash.new { [] }
    accounts.each do |account|
      make_account_debits(account).each do |account_debits|
        if @account_debits.key? account_debits.key
          @account_debits[account_debits.key].merge account_debits
        else
          @account_debits[account_debits.key] = account_debits
        end
      end
    end
  end

  def make_account_debits account
    account.debits_coming(debit_period).map do |debit|
      AccountDebit.new(date_due: debit.at_time.to_date,
                       charge_type: debit.charge_type,
                       property_ref: account.property.human_ref,
                       amount: debit.amount)
    end
  end
end
