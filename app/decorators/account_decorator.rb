require_relative '../../lib/modules/method_missing'

####
#
# AccountDecorator
#
# AccountDecorator prepares credits and debits and allows them
# to be viewed
#
# rubocop: disable Style/TrivialAccessors
####
#
class AccountDecorator
  include MethodMissing

  def account
    @source
  end

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
    date_of = Time.zone.local(Time.zone.now.year, 1, 1)
    running_balance [balance_bought_forward(date_of)] +
      ordered_items.select { |item| item.on_date >= date_of }
  end

  private

  def balance_bought_forward date_of
    AccountBalanceDecorator.new(account.balance(to_date: date_of), date_of)
  end

  def ordered_items
    [*account.debits.map { |debit| AccountDebitDecorator.new debit },
     *account.credits.map { |credit| AccountCreditDecorator.new credit }]
      .sort_by(&:on_date)
  end

  def running_balance items
    running_balance = 0
    items.map do |item|
      item.running_balance = running_balance += item.amount
      item
    end
  end
end
