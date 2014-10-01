require 'csv'
require 'rails_helper'
# require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_balance'

####
#
# import_debit_spec.rb
#
# unit testing for ImportDebit
# rubocop: disable Metrics/LineLength
#
####
#
module DB
  describe ImportBalance, :import do
    describe 'unnamed debit only one charge' do
      def row charge_code: 'GR', description: 'Balance'
        %(122, #{charge_code}, 2004-03-24 00:00:00, #{description}, 37.5,    0, 37.5)
      end

      describe 'balance from description' do
        it 'balance with one charge as arrears for that charge' do
          cycle = charge_cycle_new(due_ons: [DueOn.new(month: 3, day: 25)])
          property_create \
            human_ref: 122,
            account: account_new(charge: charge_new(charge_cycle: cycle))

          expect { ImportBalance.import parse row }
            .to change(Debit, :count).by 1

        end
        # it 'errors if charge code does not match account charge' do
        # end
      end

      # describe 'balance with subject' do
      #   it 'balance for multiple charges it matches description to charge' do
      #   end
      #   it 'errors if it cannot match description to a charge' do
      #   end
      # end
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
