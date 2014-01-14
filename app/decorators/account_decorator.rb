require_relative '../../lib/modules/method_missing'

class AccountDecorator
  include MethodMissing

  def initialize account
    @source = account
  end

  def items
    [ *@source.debits.map { |d| AccountDebitDecorator.new d },
      *@source.credits.map { |c| AccountCreditDecorator.new c } ]
    .sort_by(&:on_date)
  end

  def abbrev_items
    date = Date.current.at_beginning_of_year

    [ AccountBalanceDecorator.new(balance_on_date(date), Date.current.at_beginning_of_year),
      *@source.debits.select { |d| d.on_date >= date }
              .map { |d| AccountDebitDecorator.new d } ,
      *@source.credits.select { |d| d.on_date >= date }
              .map { |c| AccountCreditDecorator.new c } ]
    .sort_by(&:on_date)
  end

  private

  def balance_on_date date
    @source.credits
           .select { |c| c.on_date < date }
           .map { |c| c.amount }
           .inject(0,:+)  -
    @source.debits
           .select { |d| d.on_date < date }
           .map { |d| d.amount }
           .inject(0,:+)
  end
end
