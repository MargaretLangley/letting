module DB
  #####
  #
  # ChargedInFields
  #
  # Provides the chargedIn value from supplied charge fields.
  #
  # The charge import process takes rows of acc_info.csv and creates database
  # rows in the charges table. This objects takes fields from charge_row and
  # converts them into the ChargedInIds. There are a number of rules
  # used by the legacy application to decide this and this objects wraps them up.
  #
  #####
  #
  class ChargedInFields
    # Mapping of imported values to application values
    # Definitive values charged_in.csv/charged_ins table;
    LEGACY_CODE_TO_CHARGED_IN  = { '0'  => 1,     # Arrears
                                   '1' =>  2,     # Advance
                                   'M' =>  3 }    # Mid_term
    def initialize(charged_in_code:, charge_type:)
      @charged_in_code = charged_in_code
      @charge_type = charge_type
    end

    def id
      return 2 if advanced_charge_type
      LEGACY_CODE_TO_CHARGED_IN.fetch(@charged_in_code)
    end

    # charged_in_code is not set properly when the charge_type is
    # always advanced. insurance is advanced but the data left as
    # default - arrears. This hack fixes the legacy data.
    def advanced_charge_type
      @charge_type == 'Insurance' || @charge_type == 'Garage Insurance'
    end
  end
end
