require_relative '../../lib/modules/method_missing'

####
#
# AccountDecorator
#
# AccountDecorator prepares credits and debits and allows them
# to be viewed
#
####
#
class AccountDecorator
  include MethodMissing

  def initialize account
    @source = account
  end

  # Transactions covering all time
  #
  def items
    running_balance ordered_items
  end

  # Transactions covering recent period (typically this year only)
  #
  def abbrev_items
    date_of = Date.current.at_beginning_of_year
    running_balance [balance_bought_forward(date_of)] +
                    ordered_items.select { |item| item.on_date >= date_of }
  end

  private

  def balance_bought_forward date_of
    AccountBalanceDecorator.new(@source.balance(date_of), date_of)
  end

  def ordered_items
    [*@source.debits.map { |debit| AccountDebitDecorator.new debit },
     *@source.credits.map { |credit| AccountCreditDecorator.new credit }]
    .sort_by(&:on_date)
  end

  def running_balance items
    running_balance = 0
    items.map do |item|
      running_balance += item.amount
      item.running_balance = running_balance
      item
    end
  end
end
