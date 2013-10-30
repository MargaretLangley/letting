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

    def initialize contents, patch
      super Property, contents, patch
    end

    def import_loop
      @contents.each_with_index do |row, index|
        if debit? row
          ImportDebit.import @contents.slice(index..index)
        else
          ImportPayment.import @contents.slice(index..index)
        end
        show_running index
      end
    end

    def debit? row
      row[:debit].to_f != 0
    end
  end
end
