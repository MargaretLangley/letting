require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'

module DB
  ####
  #
  # DebitRow
  #
  # Wrapps around an imported row of data.
  #
  # Called during the Importing of accounts information.
  # Debits are passed to ImportDebit and during the imported
  # row is wrapped with this DebitRow. During the importing
  # the data needs to relate to other imported rows, charges
  # in this case, and this is hides this behaviour from the
  # ImportDebit.
  #
  ####
  #
  class DebitRow
    include MethodMissing

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref]
    end

    def amount
      debit
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail DB::ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def charge_id
      property = Property.find_by(human_ref: human_ref)
      fail DB::PropertyRefUnknown, property_unknown_message, caller \
        unless property
      charge = Charge.find_by account_id: property.account.id,
                              charge_type: charge_type
      fail DB::ChargeUnknown, charge_unknown_message, caller unless charge
      charge.id
    end

    def attributes
      {
        charge_id: charge_id,
        on_date: on_date,
        amount: amount,
        debit_generator_id: -1,
      }
    end

    private

    def charge_code
      @source[:charge_code]
    end

    def on_date
      @source[:on_date]
    end

    def debit
      debit = @source[:debit].to_f
      if negative_credit?
        puts "Property #{human_ref}: converting negative credit to debit"
        debit = credit * -1
      end
      debit
    end

    def negative_credit?
      credit < 0
    end

    def credit
      @source[:credit].to_f
    end

    def charge_code_message
      "Property #{human_ref}: " \
      "Charge code #{charge_code} can not be converted into a string"
    end

    def property_unknown_message
      "Property ref: #{human_ref} is unknown."
    end

    def charge_unknown_message
      "Charge '#{charge_type}' not found in property " \
      "'#{human_ref || 'unknown' }'"
    end
  end
end
