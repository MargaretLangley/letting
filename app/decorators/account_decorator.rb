require_relative 'method_missing'

class AccountDecorator
  include MethodMissing

  def initialize account
    @source = account
    @aggregated_items = []
    @account_items = []
  end

  def items
    generate_items if @account_items.empty?
    @account_items
  end

  def abbrev_items
    generate_aggregated_items if @aggregated_items.empty?
    @aggregated_items
  end

  private

  def generate_items
    @account_items.push(*@source.debits.map { |d| AccountDebitDecorator.new d })
    @account_items.push(*@source.credits.map { |c| AccountCreditDecorator.new c })
    @account_items.sort_by!(&:on_date)
    @account_items
  end

  def generate_aggregated_items
    date = Date.current.at_beginning_of_year
    balance = balance_on_date date
    @aggregated_items.push(*@source.debits.select { |d| d.on_date >= date }
                                           .map { |d| AccountDebitDecorator.new d })
    @aggregated_items.push(*@source.credits.select { |d| d.on_date >= date }
                                            .map { |c| AccountCreditDecorator.new c })
    @aggregated_items.sort_by!(&:on_date)
    @aggregated_items.unshift AccountBalanceDecorator.new balance, Date.current.at_beginning_of_year
  end

  def balance_on_date date
    items_to_balance = []
    items_to_balance.push(*@source.debits.select { |d| d.on_date < date }
                                          .map { |d| AccountDebitDecorator.new d })
    items_to_balance.push(*@source.credits.select { |d| d.on_date < date }
                                           .map { |c| AccountCreditDecorator.new c })
    items_to_balance.reduce(0) { |a, e| a + e.balance }
  end
end
