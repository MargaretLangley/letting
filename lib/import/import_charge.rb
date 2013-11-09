require_relative 'import_base'
require_relative 'charge_values'
require_relative 'day_month'
require_relative 'charge_row'

module DB
  ####
  #
  # ImportCharge
  #
  # Load, assigns and saves Charge model objects into the database
  #
  # ImportCharge is called as part of the import.rake task. It reads in
  # a charge.csv file and creates the charge objects and saves them to
  # charges and due_ons tables.
  #
  # ImportCharge has model_prepared and model_assignment called
  # by ImportBase as part of its import_loop. The private code handles
  # converting the charge.csv into charges (the actual amount) and due_ons
  # (the date when the charge is due).
  #
  ####
  #
  class ImportCharge < ImportBase
    MONTHS_IN_YEAR = 12

    def initialize contents, range, patch
      super Charge, contents, range, patch
    end

    def row= row
      @row = ChargeRow.new(row)
    end

    def model_prepared
      @model_to_save = find_model!(Property).first
      @model_to_assign =
        ChargesMatcher
          .new(@model_to_save.account.charges).first_or_initialize \
          row.charge_type
      @model_to_save.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    # true filters
    # false allows
    #
    def filtered_condition
      @range.exclude? row[:human_ref].to_i
    end

    def model_assignment
      @model_to_assign.assign_attributes row.attributes
      assign_due_ons
    end

    private

    def assign_due_ons
      day_months = charged_days_in_year
      @model_to_assign.due_ons
        .first(day_months.size).each_with_index do |due_on, index|
        assign_due_on due_on, day_months[index]
      end
    end

    def assign_due_on due_on, day_month
      due_on.attributes = { day: day_month.day, month: day_month.month } \
                                  unless ignored_date_combination day_month
    end

    def ignored_date_combination day_month
      # import data using 0 and -1 to mean null
      day_month.day == 0 && (day_month.month == 0 || day_month.month == -1)
    end

    def charged_days_in_year
      if row.monthly_charge?
        charged_days_in_year_from_monthly_charge
      else
        charged_days_in_year_from_on_date_charge
      end
    end

    def charged_days_in_year_from_monthly_charge
      [*DayMonth.from_day_month(row.day(1), DueOn::PER_MONTH)]
    end

    def charged_days_in_year_from_on_date_charge
      day_months = []
      (1..row.maximum_dates)
        .each { |index| day_months << day_month_from_row_columns(index) }
      day_months
    end

    def day_month_from_row_columns number
      DayMonth.from_day_month row.day(number), row.month(number)
    end
  end
end
