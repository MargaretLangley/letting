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

    context 'debit' do

      it 'One debit' do
        expect { ImportAccount.import one_debit_csv }.to \
          change(Debit, :count).by 1
      end

      it 'debit with credit' do
        expect { ImportAccount.import debit_with_credit_csv }.to \
          change(Credit, :count).by 1
      end

      it '2 debits, 1 credit covering 1 debit' do
        expect { ImportAccount.import two_debit_with_credit_csv }.to \
          change(Credit, :count).by 1
        expect(Debit.all).to have(2).items
      end

      it '1 credit covering multiple debit' do
        expect { ImportAccount.import credit_cover_multiple_debit_csv }.to \
          change(Credit, :count).by 2
        expect(Debit.all).to have(2).items
      end

    end

    def one_debit_csv
      FileImport.to_a('one_debit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def debit_with_credit_csv
      FileImport.to_a('debit_with_credit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def two_debit_with_credit_csv
      FileImport.to_a('two_debit_with_credit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def credit_cover_multiple_debit_csv
      FileImport.to_a('credit_cover_multiple_debit',
                      headers: FileHeader.account,
                      location: import_dir)
    end

    def import_dir
      'spec/fixtures/import_data/accounts'
    end
  end
end
