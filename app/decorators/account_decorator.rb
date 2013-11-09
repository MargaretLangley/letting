class AccountDecorator
  def initialize account
    @account = account
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
    @account_items.push(*@account.debits.map { |d| AccountDebitDecorator.new d })
    @account_items.push(*@account.credits.map { |c| AccountCreditDecorator.new c })
    @account_items.sort_by!(&:on_date)
    @account_items
  end

  def generate_aggregated_items
    date = Date.current.at_beginning_of_year
    balance = balance_on_date date
    @aggregated_items.push(*@account.debits.select { |d| d.on_date >= date }
                                           .map { |d| AccountDebitDecorator.new d })
    @aggregated_items.push(*@account.credits.select { |d| d.on_date >= date }
                                            .map { |c| AccountCreditDecorator.new c })
    @aggregated_items.sort_by!(&:on_date)
    @aggregated_items.unshift AccountBalanceDecorator.new balance, Date.current.at_beginning_of_year
  end

  def balance_on_date date
    items_to_balance = []
    items_to_balance.push(*@account.debits.select { |d| d.on_date < date }
                                          .map { |d| AccountDebitDecorator.new d })
    items_to_balance.push(*@account.credits.select { |d| d.on_date < date }
                                           .map { |c| AccountCreditDecorator.new c })
    items_to_balance.reduce(0) { |accumulator, acc_item| accumulator + acc_item.balance }
  end

  def method_missing method_name, *args, &block
    @account.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @account.respond_to?(method_name, include_private) || super
  end
end
