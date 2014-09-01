def payment_new account_id: 1,
                on_date: '30/4/2013',
                amount: 88.08,
                credit: credit
  payment = Payment.new account_id: account_id,
                        on_date: on_date,
                        amount: amount
  payment.credits << credit if credit
  payment
end
