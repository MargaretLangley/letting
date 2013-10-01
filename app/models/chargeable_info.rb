class ChargeableInfo
  attr_reader :charge_id, :on_date, :amount

  def self.from_charge args = {}
    new charge_id: args[:charge_id], \
        on_date:   args[:on_date], \
        amount:    args[:amount]
  end

  def == another_debt_info
    self.charge_id == another_debt_info.charge_id && \
    self.on_date == another_debt_info.on_date && \
    self.amount == another_debt_info.amount
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
  end
end