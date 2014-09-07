# rubocop: disable Style/MethodLength

def credit_new payment_id: 1,
               account_id: 1,
               charge_id: 1,
               on_date: '30/4/2013',
               amount: -88.08
  base_credit payment_id: payment_id,
              account_id: account_id,
              charge_id: charge_id,
              on_date: on_date,
              amount: amount
end

def credit_create payment_id: 1,
                  account_id: 1,
                  charge_id: 1,
                  on_date: '30/4/2013',
                  amount: -88.08
  credit = base_credit payment_id: payment_id,
                       account_id: account_id,
                       charge_id: charge_id,
                       on_date: on_date,
                       amount: amount
  credit.save!
  credit
end

def base_credit(payment_id:, account_id:, charge_id:, on_date:, amount:)
  credit = Credit.new payment_id: payment_id,
                      account_id: account_id,
                      charge_id: charge_id,
                      on_date: on_date,
                      amount: amount
  allow(credit).to receive(:debit_outstanding).and_return(-88.08)
  credit
end
