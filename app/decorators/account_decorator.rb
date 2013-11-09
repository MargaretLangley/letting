

class AccountDecorator

  def initialize account
    @account = account
    @account_items = []
  end

  def items
    @account_items.push *@account.debits.map{|d| AccountDebitDecorator.new d}
    @account_items.push *@account.credits.map{|c| AccountCreditDecorator.new c}
    @account_items.sort_by &:on_date
  end


  private

  def method_missing method_name, *args, &block
    @account.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @account.respond_to?(method_name, include_private) || super
  end
end
