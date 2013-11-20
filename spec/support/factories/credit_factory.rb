def credit_new args = {}
  credit = Credit.new credit_attributes args
  credit.stub(:debit_outstanding).and_return 88.08
  credit
end

def credit_in_advance_new args = {}
  credit = Credit.new (credit_attributes advance: true, debit_id: nil, amount: 0).merge args
  credit.stub(:debit_outstanding).and_return 0
  credit
end
