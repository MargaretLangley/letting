require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/account_row'

####
# AccountRow Spec
#
# Testing the import of Account rows.
#
# rubocop: disable  Metrics/ParameterLists
# rubocop: disable  Metrics/LineLength
####
module DB
  describe AccountRow,  :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-25',
            credit_amount: 5.5,
            description: 'Ground Rent',
            debit_amount: 0
      AccountRow.new parse_line \
      %(#{human_ref}, #{charge_code}, #{date}, #{description}, #{debit_amount}, #{credit_amount}, 0)
    end

    describe 'attributes' do
      it('human_ref') { expect(row(human_ref: 9).human_ref).to eq 9 }
      it 'charge_code' do
        expect(row(charge_code: 'GR').charge_code).to eq 'GR'
      end
    end

    describe 'methods' do
      describe '#credit?' do
        it 'returns true when credit' do
          expect(row(credit_amount: 1, debit_amount: 0)).to be_credit
        end
        it 'returns false when debit' do
          expect(row(credit_amount: 0, debit_amount: 1)).to_not be_credit
        end
      end
      describe '#debit?' do
        it 'returns true when debit' do
          expect(row(credit_amount: 0, debit_amount: 1)).to be_debit
        end
        it 'returns true when negative credit' do
          expect(row(credit_amount: -1, debit_amount: 0)).to be_debit
        end
        it 'returns false when credit' do
          expect(row(credit_amount: 1, debit_amount: 0)).to_not be_debit
        end
      end
      describe '#amount' do
        it 'returns debit amount when debit' do
          expect(row(credit_amount: 0, debit_amount: 1).amount).to eq(1)
        end
        it 'returns credit amount when credit' do
          expect(row(credit_amount: 1, debit_amount: 0).amount).to eq(1)
        end
        it 'returns debit by default' do
          expect(row(credit_amount: 1, debit_amount: 2).amount).to eq(2)
        end
      end

      describe '#balance?' do
        it 'returns true when charge code has balance' do
          expect(row(charge_code: 'Bal')).to be_balance
        end

        it 'returns true when description has balance' do
          expect(row(description: 'Balance')).to be_balance
        end
        it 'returns false when credit row' do
          expect(row(credit_amount: 1)).to_not be_balance
        end
        it 'returns false when debit row' do
          expect(row(debit_amount: 1)).to_not be_balance
        end
      end

      describe 'on_date' do
        it 'returns date' do
          expect(row(date: '2012-12-10 16:41:00').on_date)
            .to eq Date.new 2012, 12, 10
        end
        it 'handles bad date' do
          expect { row(date: 'd-0x-dd').on_date }.to raise_error ArgumentError
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end
  end
end
