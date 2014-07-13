def credit_new args = {}
  credit = Credit.new credit_attributes args
  allow(credit).to receive(:debit_outstanding).and_return 88.08
  credit
end
