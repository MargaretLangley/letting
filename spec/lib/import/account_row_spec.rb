require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/account_row'

module DB
  describe AccountRow do

    context 'credit row' do
      let(:row) { AccountRow.new parse_line credit_row }
      it 'has human_ref' do
        expect(row.human_ref).to eq '89'
      end
      it 'is credit row' do
        expect(row).to be_credits
      end
      it 'is not debit row' do
        expect(row).to_not be_debits
      end
      it 'calculates amount' do
        expect(row.amount).to eq 50.5
      end

      context 'ChargeType' do
        it 'returns chargeType' do
          expect(row.charge_type).to eq 'Ground Rent'
        end
      end
    end

    context 'debit row' do
      let(:row) { AccountRow.new parse_line debit_row }

      it 'is not credit row' do
        expect(row).to_not be_credits
      end

      it 'is debit row' do
        expect(row).to be_debits
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                      { headers: FileHeader.account,
                        header_converters: :symbol,
                        converters: lambda { |f| f ? f.strip : nil } }
                    )
    end

    def credit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end

    def debit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0]
    end

  end
end
