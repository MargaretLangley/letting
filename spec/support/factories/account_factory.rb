def account_new charge: nil, credit: nil, debit: nil, payment: nil,**args
  account = base_account args
  account.charges << charge if charge
  account.credits << credit if credit
  account.debits << debit if debit
  account.payments << payment if payment
  account
end

private

def base_account **args
  account = Account.new account_attributes
  account.id = args[:id] if args[:id]
  account.property_id = args[:property_id] if args[:property_id]
  account
end
