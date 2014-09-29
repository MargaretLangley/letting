# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def debit_new account_id: 1,
              charge_id: nil,
              charge: nil,
              on_date: '25/3/2013',
              period: Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
              amount: 88.08
  debit = Debit.new account_id: account_id,
                    on_date: on_date,
                    period: period,
                    amount: amount
  debit.charge_id = charge_id if charge_id
  debit.charge = charge if charge
  debit
end

def debit_create account_id: 1,
                 charge_id: nil,
                 charge: nil,
                 on_date: '25/3/2013',
                 period: Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
                 amount: 88.08
  debit = debit_new account_id: account_id,
                    on_date: on_date,
                    period: period,
                    charge_id: charge_id,
                    charge: charge,
                    amount: amount
  debit.save!
  debit
end
