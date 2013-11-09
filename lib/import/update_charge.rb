module DB
  class UpdateCharge
    def self.do
      new.update
    end

    def update
      add_charge_range_dates
      update_recent_stopped_charges
    end

    def add_charge_range_dates
      Charge.all.each do |charge|
        @charge = charge
        @charge.start_date = first_debit.on_date if first_debit
        @charge.end_date = last_debit.on_date if stopped_debiting?
        charge.save!
      end
    end

    def first_debit
      @charge.debits(order: :on_date).last
    end

    def last_debit
      @charge.debits(order: :on_date).first
    end

    def stopped_debiting?
      last_debit && last_debit.on_date < within_a_year
    end

    def within_a_year
      Date.current - 1.years
    end

    def update_recent_stopped_charges
      # It's a hack while only 1 needs to be changed
      property = Property.find_by(human_ref: 6531)
      if property
        charges = property.account.charges
        charge = charges.find_by(charge_type: 'Insurance')
        if charge.present?
          @charge = charge
          @charge.end_date = last_debit.on_date
          charge.save!
        end
      end
    end
  end
end
