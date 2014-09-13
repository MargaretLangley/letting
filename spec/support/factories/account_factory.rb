def account_new id: nil, charge: nil, credit: nil, debit: nil, payment: nil
  account = Account.new id: id
  account.charges << charge if charge
  account.credits << credit if credit
  account.debits << debit if debit
  account.payments << payment if payment
  account
end
