require_relative 'import_base'

module DB
  ####
  #
  # ImportAccountProfile
  #
  # Imports billing profiles (shipping addreses for properties)
  #
  # Uses ImportBase and is called during the import process and at no
  # other time.
  #
  ####
  #
  class AccountRow
    def initialize row
      @row = row
    end

    def human_id
      @row[:human_id]
    end

    def debits?
      @row[:debit] != '0'
    end

    def credits?
      @row[:credit] != '0'
    end

    def attributes
      debits? ? debit_attributes : credit_attributes
    end

    private

     def debit_attributes
       { charge_id: -1,
       on_date: @row[:on_date],
       amount: @row[:debit],
       debit_generator_id: -1 }
     end

     def credit_attributes
       raise_error ActiveRecord::RecordNotFound
     end

  end

  class ImportAccount < ImportBase

    def initialize contents, patch
      super Property, contents, patch
    end

    def model_prepared_for_import row
      account_row = AccountRow.new(row)
      @model_to_save = parent_model row, Property \
        unless eq_ref? @model_to_save, account_row
      @model_to_assign = model_to_assign row
    end

    def model_assignment row
      @model_to_assign.attributes = AccountRow.new(row).attributes
    end

    private

    def model_to_assign row
      AccountRow.new(row).debits? ? @model_to_save.account.debits.build :
                                    @model_to_save.account.credits.build
    end

    def eq_ref? last_human_ref, current_human_ref
      @model_to_save.present? && account_row.present? &&
        @model_to_save.human_id == account_row.human_id
    end

  end
end
