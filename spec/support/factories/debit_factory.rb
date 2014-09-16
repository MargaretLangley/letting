# rubocop: disable Metrics/MethodLength

def debit_new account_id: 1,
              debit_generator_id: 1,
              charge_id: 1,
              on_date: '25/3/2013',
              amount: 88.08
  base_debit account_id: account_id,
             debit_generator_id: debit_generator_id,
             charge_id: charge_id,
             on_date: on_date,
             amount: amount
end

def debit_create account_id: 1,
              debit_generator_id: 1,
              charge_id: 1,
              on_date: '25/3/2013',
              amount: 88.08
  debit = base_debit account_id: account_id,
                     debit_generator_id: debit_generator_id,
                     charge_id: charge_id,
                     on_date: on_date,
                     amount: amount
  debit.save!
  debit
end

def base_debit(account_id:, debit_generator_id:, charge_id:, on_date:, amount:)
  debit = Debit.new account_id: account_id,
                    debit_generator_id: debit_generator_id,
                    charge_id: charge_id,
                    on_date: on_date,
                    amount: amount
  debit
end
