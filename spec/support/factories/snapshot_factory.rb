def snapshot_new id: nil, debits: [debit_new(charge: charge_new)]
  snapshot = Snapshot.new id: id
  snapshot.debited debits: debits if debits
  snapshot
end
