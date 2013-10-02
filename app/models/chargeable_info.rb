class ChargeableInfo
  attr_reader :account_id, :charge_id, :on_date, :amount

  def self.from_charge args = {}
    new charge_id: args[:charge_id], \
        on_date:   args[:on_date], \
        amount:    args[:amount], \
        account_id: args[:account_id]
  end

  def == other
    charge_id == other.charge_id && \
    on_date == other.on_date && \
    amount == other.amount && \
    account_id == other.account_id
  end

  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  private

  def initialize args = {}
    @charge_id = args[:charge_id]
    @on_date = args[:on_date]
    @amount = args[:amount]
    @account_id = args[:account_id]
  end
end