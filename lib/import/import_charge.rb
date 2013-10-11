require_relative 'import_base'
require_relative 'charge_values'
require_relative 'day_month'

module DB
  class ImportCharge < ImportBase

    MONTHS_IN_YEAR = 12
    DUE_IN_CODE_TO_STRING  = { '0'  => 'Arrears',
                               '1' => 'Advance',
                               'M' => 'MidTerm' }

    def initialize contents, patch
      super Charge, contents, patch
    end

    def model_prepared_for_import row
      @model_to_save = parent_model row, Property
      @model_to_assign =
        ChargesMatcher
          .new(@model_to_save.account.charges).first_or_initialize \
            ChargeValues.from_code(row[:charge_type]).charge_code
      @model_to_save.prepare_for_form
    end

    def model_assignment row
      @model_to_assign
        .assign_attributes \
           charge_type: ChargeValues.from_code(row[:charge_type]).charge_code,
           due_in:      DUE_IN_CODE_TO_STRING[row[:due_in]],
           amount:      row[:amount].to_d
      assign_due_ons row
    end

    def assign_due_ons row
      day_months = charged_days_in_year(row)
      @model_to_assign.due_ons
        .first(day_months.size).each_with_index do |due_on, index|
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
      DayMonth.from_day_month row[:"day_#{number}"].to_i,
                              row[:"month_#{number}"].to_i
    end

    def ignored_date_combination day_month
      # import data using 0 and -1 to mean null
      day_month.day == 0 && (day_month.month == 0 || day_month.month == -1)
    end

    def charged_days_in_year row
      if monthly_charge? row
        charged_days_in_year_from_monthly_charge row
      else
        charged_days_in_year_from_on_date_charge row
      end
    end

    def charged_days_in_year_from_on_date_charge row
      day_months = []
      (1..maximum_dates(row))
        .each { |index| day_months <<  day_month_from_row_columns(index, row) }
      day_months
    end

    def charged_days_in_year_from_monthly_charge row
      monthly_charge = day_month_from_row_columns 1, row
      [*DayMonth.from_day_month(monthly_charge.day, DueOn::PER_MONTH)]
    end
  end
end
