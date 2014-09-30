
require_relative '../modules/method_missing'
require_relative 'accounting_row'
require_relative 'charge_code'
require_relative 'errors'

module DB
  ####
  #
  # CreditRow
  #
  # Wraps around an imported row of data acc_items.
  #
  # Called during the Importing of accounts information.
  # Credit rows are selected and passed to ImportCredit by the
  # ImportAccount object.
  # During the importing the row is wrapped with this CreditRow. Credit object
  # needs to relate to other database objects, charges in this case, and some
  # data fields needs to be converted into different types;
  # this class is responsible for data conversion of the csv field and leaves
  # ImportCredit to create/assign database objects (Credits) and their related
  # fields.
  #
  ####
  #
  class CreditRow
    include MethodMissing
    include AccountingRow

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref]
    end

    def charge_code
      @source[:charge_code]
    end

    def on_date
      @source[:on_date]
    end

    # credits decrease an account balance.
    # credit amounts are negative (-)
    # credit amounts are imported (from acc_items) without a sign
    #
    def amount
      @source[:credit]
    end

    def account_id
      account(human_ref: human_ref).id
    end

    def charge_id
      charge(account: account(human_ref: human_ref),
             charge_type: charge_type).id
    end

    def charge_type
      charge_code_to_s(charge_code: charge_code,
                       human_ref: human_ref)
    end

    def payment_attributes
      {
        account_id: account_id,
        booked_on: on_date,
        amount: amount,
      }
    end
  end
end
