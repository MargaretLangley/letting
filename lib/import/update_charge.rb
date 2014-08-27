####
#
# UpdateCharge
#
# Charges run from a start_date to an end date. The previous system
# deleted charges that were stopped. This system bands the range
# that a charge has been active. It has to derive this data from
# debits that have been made against the charge.
#
# UpdateCharge requires Charges and debits to be loaded into the
# database to work.
#
####
#
module DB
  class UpdateCharge
    def self.do
      new.update
    end

    def update
      assign_range_dates
      update_recent_stopped_charges
    end

    private

    def assign_range_dates
      Charge.all.each do |charge|
        @charge = charge
        @charge.start_date = first_debit.on_date if first_debit
        @charge.end_date = last_debit.on_date if stopped_debiting?
        @charge.save!
      end
    end

    def first_debit
      @charge.debits.order('on_date ASC').first
    end

    def last_debit
      @charge.debits.order('on_date ASC').last
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
      return unless property

      charge = property.account.charges.find_by(charge_type: 'Insurance')
      return unless charge.present?

      @charge = charge
      @charge.end_date = last_debit.on_date
      charge.save!
    end
  end
end
