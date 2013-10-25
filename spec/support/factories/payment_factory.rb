def payment_new args = {}
  payment = Payment.new payment_attributes args
  payment.credits << credit_new
  payment
end
