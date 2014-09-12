def payment_new account_id: 1,
                booked_on: '30/4/2013',
                amount: 88.08,
                credit: credit
  base_payment account_id: account_id,
               booked_on: booked_on,
               amount: amount,
               credit: credit
end

def payment_create account_id: 1,
                   booked_on: '30/4/2013',
                   amount: 88.08,
                   credit: credit
  payment = base_payment account_id: account_id,
                         booked_on: booked_on,
                         amount: amount,
                         credit: credit
  payment.save!
  payment
end

def base_payment(account_id:, booked_on:, amount:, credit:)
  payment = Payment.new account_id: account_id,
                        booked_on: booked_on
  payment.amount = amount if amount
  payment.credits << credit if credit
  payment
end
