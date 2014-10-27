module DB
  #####
  #
  # LegacyChargedInFields
  #
  # Provides the chargedIn value from supplied charge fields.
  #
  # The charge import process takes rows of acc_info.csv and creates database
  # rows in the charges table. This objects takes fields from charge_row and
  # converts them into the ChargedInIds. There are a number of rules
  # used by the legacy application to decide this and this objects wraps them
  # up.
  #
  #    Charged in column/attributes throughout program
  #
  #    Where           AccInfo  file_header/import  Cycle
  #    Legacy/modern   Legacy   Legacy              Modern
  #    field/attribute AdvArr   charged_in          charged_in
  #
  #    Legacy "0" =>  Modern 1
  #    Legacy "1" =>  Modern 2
  #    Legacy "M" =>  Modern 3
  #####
  #
  class LegacyChargedInFields
    attr_reader :charged_in_code, :charge_type
    # Mapping of imported values to application values
    # Definitive values charged_in.csv/charged_ins table;
    LEGACY_CODE_TO_CHARGED_IN  = { '0'  => 1,     # Arrears
                                   '1' =>  2,     # Advance
                                   'M' =>  3 }    # Mid_term
    def initialize(charged_in_code:, charge_type:)
      @charged_in_code = charged_in_code
      @charge_type = charge_type
    end

    # returns the modern application's id
    # so: "0" => 1, "1" => 2, "M" => 3
    #
    def modern_id
      return 1 if charged_in_code == 'M' # Only mid-term is an arrears
      return 2 if advanced_charge_type
      LEGACY_CODE_TO_CHARGED_IN.fetch(charged_in_code)
    end

    # charged_in_code is not set properly when the charge_type is
    # always advanced. insurance is advanced but the data left as
    # default - arrears. This hack fixes the legacy data.
    def advanced_charge_type
      charge_type == 'Insurance' || charge_type == 'Garage Insurance'
    end
  end
end
