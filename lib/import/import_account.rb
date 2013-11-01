require_relative 'import_base'
require_relative 'account_row'
require_relative 'creditable_amount'
require_relative 'import_debit'
require_relative 'import_payment'

module DB
  ####
  #
  # ImportAccount
  #
  #
  ####
  #


  class ImportAccount < ImportBase

    def initialize  contents, range, patch
      super Property, contents, range, patch
    end

    def import_row
      case
      when debit?
        ImportDebit.import [row]
      when credit?
        ImportPayment.import [row]
      else
        # TODO handle bal codes
      end
    end

    def credit?
      row[:credit].to_f != 0
    end

    def debit?
      row[:debit].to_f != 0
    end

    def charge_code
      row[:charge_code]
    end
  end
end
