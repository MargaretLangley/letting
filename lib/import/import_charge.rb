require_relative 'import_base'
require_relative 'charge_values'
require_relative 'day_month'

module DB
  class ImportCharge < ImportBase

    DueInCodeToString  = { '0'  => 'Arrears', '1' => 'Advance', 'M' => 'MidTerm'}
    MONTHS_IN_YEAR = 12

    def initialize contents, patch
      super Charge, contents, patch
    end

    def model_prepared_for_import row
      @model_to_save = first_model row, Property
      @model_to_assign = @model_to_save.charges.first_or_initialize \
                                ChargeValues.from_code(row[:charge_type]).charge_code
      @model_to_save.prepare_for_form
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes \
                         charge_type: ChargeValues.from_code(row[:charge_type]).charge_code, \
                         due_in:      DueInCodeToString[ row[:due_in] ], \
                         amount:      row[:amount].to_d
      assign_due_ons row
    end

    def assign_due_ons row
      day_months = []
      if monthly_charge? row
         monthly_charge = day_month_from_row_columns 1, row
         day_months << DayMonth.from_day_month( monthly_charge.day, DueOn::PER_MONTH )
        # (1..MONTHS_IN_YEAR).each {|index| day_months <<  DayMonth.from_day_month( monthly_charge.day, index ) }
      else
        (1..maximum_dates(row)).each {|index| day_months <<  day_month_from_row_columns( index, row ) }
      end

      @model_to_assign.due_ons.first(day_months.length).each_with_index do |due_on, index|
        assign_due_on due_on, day_months[index]
      end
    end

    def assign_due_on due_on, day_month
      due_on.attributes = { day: day_month.day, month: day_month.month } \
                                  unless ignored_date_combination day_month
    end

    def maximum_dates row
      ChargeValues.from_code(row[:charge_type]).max_dates_per_year
    end

    def monthly_charge? row
      (day_month_from_row_columns 1, row).month == 0
    end

    def day_month_from_row_columns number, row
      DayMonth.from_day_month \
            row[:"day_#{number}"].to_i,  \
            row[:"month_#{number}"].to_i
    end


    def ignored_date_combination day_month
      # import data using 0 and -1 to mean null
      day_month.day == 0 && ( day_month.month == 0 || day_month.month == -1 )
    end
  end
end