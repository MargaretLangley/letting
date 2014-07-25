require_relative '../../lib/modules/method_missing'

class AccountDecorator
  include MethodMissing

  def initialize account
    @source = account
  end

  def items
    running_balance = 0
    [*@source.debits.map { |debit| AccountDebitDecorator.new debit },
     *@source.credits.map { |credit| AccountCreditDecorator.new credit }]
    .sort_by(&:on_date)
    .map do |transaction|
      running_balance += transaction.amount
      transaction.balance = running_balance
      transaction
    end
  end

  def abbrev_items
    date = Date.current.at_beginning_of_year

    running_balance = balance_on_date(date)
    [AccountBalanceDecorator.new(running_balance, Date.current.at_beginning_of_year)] +
    [*@source.debits.select { |debit| debit.on_date >= date }
              .map { |debit| AccountDebitDecorator.new debit },
     *@source.credits.select { |debit| debit.on_date >= date }
             .map { |credit| AccountCreditDecorator.new credit }]
    .sort_by(&:on_date)
    .map do |transaction|
      running_balance += transaction.amount
      transaction.balance = running_balance
      transaction
    end
  end

  private

  def balance_on_date date
    @source.debits
           .select { |debit| debit.on_date < date }
           .map { |debit| debit.amount }
           .inject(0, :+) -
    @source.credits
           .select { |credit| credit.on_date < date }
           .map { |credit| credit.amount }
           .inject(0, :+)
  end
end
