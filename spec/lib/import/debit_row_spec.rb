require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/debit_row'

module DB
  describe DebitRow do
    let(:row) { DebitRow.new parse_line debit_row }

    context 'attributes' do

      it 'has human_ref' do
        expect(row.human_ref).to eq '89'
      end

      it 'calculates amount' do
        expect(row.amount).to eq 50.5
      end
    end

    context 'methods' do
      context '#charge_type' do
        it 'returns valid' do
          expect(row.charge_type).to eq 'Ground Rent'
        end

        it 'errors invalid' do
          bad_code = DebitRow.new parse_line debit_row_no_type
          expect { bad_code.charge_type }.to raise_error ChargeCodeUnknown
        end
      end
    end


    def parse_line row_string
      CSV.parse_line(row_string,
                      { headers: FileHeader.account,
                        header_converters: :symbol,
                        converters: lambda { |f| f ? f.strip : nil } }
                    )
    end

    def debit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0]
    end

    def debit_row_no_type
      %q[89, Bal, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0]
    end

  end
end
