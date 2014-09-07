def payment_new account_id: 1,
                on_date: '30/4/2013',
                amount: 88.08,
                credit: credit
  base_payment account_id: account_id,
               on_date: on_date,
               amount: amount,
               credit: credit
end

def payment_create account_id: 1,
                   on_date: '30/4/2013',
                   amount: 88.08,
                   credit: credit
  payment = base_payment account_id: account_id,
                         on_date: on_date,
                         amount: amount,
                         credit: credit
  payment.save!
  payment
end

def base_payment(account_id:, on_date:, amount:, credit:)
  payment = Payment.new account_id: account_id,
                        on_date: on_date
  payment.amount = amount if amount
  payment.credits << credit if credit
  payment
end
