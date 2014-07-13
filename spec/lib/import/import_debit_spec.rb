require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_debit'

module DB
  describe ImportDebit, :import do
    let!(:property) do
      property_with_charge_create! human_ref: 122
    end

    context 'one debit' do
      def one_debit_csv
        %q(122, GR, 2011-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5)
      end

      it 'parsed' do
        expect { ImportDebit.import parse one_debit_csv }
          .to change(Debit, :count).by 1
      end
    end

    context 'two debits' do
      def two_debit_csv
        %q(122, GR, 2011-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5
           122, GR, 2012-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5)
      end

      it 'parsed' do
        expect { ImportDebit.import parse two_debit_csv }
          .to change(Debit, :count).by 2
      end
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (f) { f ? f.strip : nil }
               )
    end
  end
end
