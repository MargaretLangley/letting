

after 'charges' do
  class << self
    def create_date months_ago
      on_date = Date.current - months_ago.months
      "#{on_date.year}/#{on_date.month }/01"
    end

    def create_payment
      payment = Payment.new id: 1,
                            account_id: 1,
                            booked_on: create_date(15)
      payment.amount = 88.08
      payment.save!
    end
  end

  Account.create! [
    { id: 1, property_id: 1 },
    { id: 2, property_id: 2 },
    { id: 3, property_id: 3 },
    { id: 4, property_id: 4 },
  ]

  Credit.create! [
    { id: 1,
      payment_id: 1,
      charge_id: 1,
      account_id: 1,
      on_date: create_date(15),
      amount: 88.08,
    },
  ]

  create_payment
end
