class Payment
  attr_reader :amount, :charge_id, :on_date, :property
  def initialize args
    @charge_type = args[:charge_id]
    @on_date = args[:on_date]
    @amount = args[:amount]
  end
end