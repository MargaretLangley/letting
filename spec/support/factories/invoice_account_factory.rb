def invoice_account_new id: nil,
                        debits: [debit_new(charge: charge_new)]

  invoice_account = InvoiceAccount.new id: id
  invoice_account.debited debits: debits if debits
  invoice_account
end
