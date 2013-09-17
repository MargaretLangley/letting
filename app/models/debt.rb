class Debt
  attr_reader :amount, :charge_id, :on_date
  def initialize args
    @charge_id = args[:charge_id]
    @on_date = args[:on_date]
    @amount = args[:amount]
  end
end