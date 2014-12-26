def snapshot_new id: nil,
                 account_id: 1,
                 period: '2000/01/01'..'2001/03/01',
                 debits: [debit_new(charge: charge_new)]

  snapshot = Snapshot.new id: id,
                          account_id: account_id,
                          period: period
  snapshot.debited debits: debits if debits
  snapshot
end

def snapshot_create id: nil,
                    account_id: 1,
                    period: '2000/01/01'..'2001/03/01',
                    debits: [debit_new(charge: charge_new)]

  snapshot = snapshot_new id: id,
                          account_id: account_id,
                          period: period,
                          debits: debits
  snapshot.save!
end
