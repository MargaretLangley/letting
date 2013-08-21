require_relative 'import_base'

module DB
  class ImportCharge < ImportBase

    ChargeCodeToString = { 'GR' => 'Ground Rent', 'SC' => 'Service Charge' }
    DueInCodeToString  = { '0'  => 'Advance', '1' => 'Arrears', 'M' => 'MidTerm'}

    def initialize contents, patch
      super Charge, contents, patch
    end

    def model_prepared_for_import row
      @model_to_save = first_model row, Property
      @model_to_assign = @model_to_save.charges.first_or_initialize \
                                        ChargeCodeToString[ row[:charge_type] ]
      @model_to_save.prepare_for_form
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes \
                         charge_type: ChargeCodeToString[ row[:charge_type] ], \
                         due_in:      DueInCodeToString[ row[:due_in] ], \
                         amount:      row[:amount].to_d
      assign_due_ons row
    end

    def assign_due_ons row
      @model_to_assign.due_ons.each_with_index do |due_on, index|
        assign_due_on due_on, index + 1, row
      end
    end

    def assign_due_on due_on, number, row
      day   = row[:"day_#{number}"].to_i
      month = row[:"month_#{number}"].to_i
      due_on.attributes = { day: day, month: month } \
        unless day == 0 && month == 0
        # import data using 0 to mean null
    end
  end
end