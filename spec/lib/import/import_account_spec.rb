require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_account'

module DB

  describe ImportAccount do
    let!(:property) do
      property_create! human_ref: 122
    end

    context 'credit' do

      it 'One row' do
        pending
        expect { ImportAccount.import one_credit_csv }.to \
          change(Credit, :count).by 1
      end
    end

    context 'debit' do

      it 'One row' do
        expect { ImportAccount.import one_debit_csv }.to \
          change(Debit, :count).by 1
      end
    end

    def one_debit_csv
      FileImport.to_a('one_debit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def one_credit_csv
      FileImport.to_a('one_credit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def import_dir
      'spec/fixtures/import_data/accounts'
    end
  end
end
