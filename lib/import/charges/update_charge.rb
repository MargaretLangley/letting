module DB
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
  class UpdateCharge
    def self.do
      new.update
    end

    def update
      assign_range_dates
      # update_recently_stopped_charges
    end

    private

    def assign_range_dates
      Charge.all.each do |charge|
        charge.start_date = first_debit(charge).on_date if first_debit charge
        charge.end_date = last_debit(charge).on_date if stopped_debiting? charge
        charge.save!
      end
    end

    def first_debit charge
      charge.debits.order('on_date ASC').first
    end

    def last_debit charge
      charge.debits.order('on_date ASC').last
    end

    def stopped_debiting? charge
      last_debit(charge) && last_debit(charge).on_date < within_a_year
    end

    def within_a_year
      Time.zone.today - 1.years
    end

    # If I need an end date for a charge ending within a year
    #
    # def update_recently_stopped_charges
    #   # It's a hack while only a few recently stopped charges
    #   # need an end date added to them.
    #   property = Property.find_by(human_ref: 6531)
    #   return unless property

    #   charge =
    #   property.account.charges.find_by(charge_type: Chargetypes::INSURANCE)
    #   return unless charge.present?

    #   @charge = charge
    #   @charge.end_date = last_debit.on_date
    #   charge.save!
    # end
  end
end
