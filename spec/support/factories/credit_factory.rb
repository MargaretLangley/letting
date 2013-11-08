def credit_new args = {}
  credit = Credit.new credit_attributes args
  credit.stub(:outstanding).and_return 88.08
  credit
end
