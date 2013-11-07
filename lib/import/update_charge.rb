module DB

  class UpdateCharge
    def self.do
      Charge.all.each do |charge|
        charge.start_date = earliest_debit_date charge
        charge.end_date = latest_debit_date(charge) \
          if latest_debit_date(charge) < within_a_year
        charge.save!
      end
    end

    def self.earliest_debit_date charge
      charge.debits(order: :on_date).last.on_date
    end

    def self.latest_debit_date charge
      charge.debits(order: :on_date).first.on_date
    end

    def self.within_a_year
      Date.current - 1.years
    end
  end
end
