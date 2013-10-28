
class AccountRow
  def initialize row
    @row = row
  end

  def human_ref
    @row[:human_ref]
  end

  def debits?
    debit != 0
  end

  def credits?
    credit != 0
  end

  def amount
    debits? ? debit : credit
  end

  def attributes
    debits? ? debit_attributes : credit_attributes
  end

  def method_missing method_name, *args, &block
    @row.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @row.respond_to?(method_name, include_private) || super
  end

  private

  def debit_attributes
    {
      charge_id: -1,
      on_date: @row[:on_date],
      amount: amount,
      debit_generator_id: -1,
    }
  end

  def credit_attributes
    {
      payment_id: -1,
      on_date: @row[:on_date],
      amount: amount,
    }
  end

  def credit
    @row[:credit].to_f
  end

  def debit
    @row[:debit].to_f
  end

end
