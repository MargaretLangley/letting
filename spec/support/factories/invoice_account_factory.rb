def debits_transaction_new id: nil,
                        debits: [debit_new(charge: charge_new)]

  debits_transaction = DebitsTransaction.new id: id
  debits_transaction.debited debits: debits if debits
  debits_transaction
end
