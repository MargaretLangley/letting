# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def payment_new id: nil,
                account_id: nil,
                account: nil,
                booked_on: Time.zone.local(2013, 4, 30, 1, 0, 0),
                amount: 88.08,
                credit: credit
  payment = Payment.new id: id,
                        account_id: account_id,
                        booked_on: booked_on
  payment.amount = amount if amount
  payment.credits << credit if credit
  payment.account_id = account_id if account_id
  payment.account = account if account
  payment
end

def payment_create id: nil,
                   account_id: nil,
                   account: nil,
                   booked_on: Time.zone.local(2013, 4, 30, 1, 0, 0),
                   amount: 88.08,
                   credit: credit
  payment = payment_new id: id,
                        account_id: account_id,
                        account: account,
                        booked_on: booked_on,
                        amount: amount,
                        credit: credit
  payment.save!
  payment
end
