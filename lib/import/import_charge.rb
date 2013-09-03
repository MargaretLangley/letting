require_relative 'import_base'
require_relative 'charge_values'
require_relative 'day_month'

module DB
  class ImportCharge < ImportBase

    DueInCodeToString  = { '0'  => 'Advance', '1' => 'Arrears', 'M' => 'MidTerm'}

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
      max_dates = ChargeValues.from_code(row[:charge_type]).max_dates_per_year
      @model_to_assign.due_ons.to_a.take(max_dates).\
          each_with_index do |due_on, index|
        assign_due_on due_on, day_month_from_row_columns(index + 1, row)
      end
    end

    def day_month_from_row_columns number, row
      DayMonth.from_day_month \
            row[:"day_#{number}"].to_i,  \
            row[:"month_#{number}"].to_i
    end

    def assign_due_on due_on, day_month
      due_on.attributes = { day: day_month.day, month: day_month.month } \
      unless ignored_date_combination day_month
    end

    def ignored_date_combination day_month
      # import data using 0 and -1 to mean null
      day_month.day == 0 && ( day_month.month == 0 || day_month.month == -1 )
    end
  end
end