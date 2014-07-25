require_relative '../../lib/modules/method_missing'

# AccountDecorator
#
# AccountDecorator prepares credits and debits and allows them
# to be viewed
#
#
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
    abbrev_before_date = Date.current.at_beginning_of_year
    previous_items, current_items =
    ordered_items.partition { |item| item.on_date < abbrev_before_date }

    running_balance \
    [AccountBalanceDecorator.new(total(previous_items), abbrev_before_date)] +
    current_items
  end

  private

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

  def total items
    items.map { |item| item.amount }.inject(0, :+)
  end
end
