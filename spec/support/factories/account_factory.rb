def account_new id: nil, charge: nil, credit: nil, debits: nil, payment: nil
  account = Account.new id: id
  account.charges << charge if charge
  account.credits << credit if credit
  account.debits = debits if debits
  account.payments << payment if payment
  account
end
