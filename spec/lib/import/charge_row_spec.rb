require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/charge_row'

module DB
  describe ChargeRow do

    context 'credit row' do
      let(:row) { ChargeRow.new parse_line charge_row }

      context 'readers' do

        it 'amount' do
          expect(row.amount).to eq 50.5
        end

      end

      context 'methods' do

        context '#charge_type' do
          it 'returns valid' do
            expect(row.charge_type).to eq 'Ground Rent'
          end

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_no_type
            expect { bad_code.charge_type }.to raise_error ChargeCodeUnknown
          end
        end

        context '#due_in' do
          it 'returns valid' do
            expect(row.due_in).to eq 'Arrears'
          end

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_invalid_due_in
            expect { bad_code.due_in }.to raise_error DueInCodeUnknown
          end
        end

      end
    end

    def parse_line row_string
      CSV.parse_line( row_string,
                      { headers: FileHeader.charge,
                        header_converters: :symbol,
                        converters: lambda { |f| f ? f.strip : nil } }
                    )
    end

    def charge_row
      %q[ 89, 2006-12-30, GR, 0, 50.5, S ] +
      %q[ 24, 3, 25, 6, 25, 9, 31, 12 ] +
      %q[ 1901-01-01, 0 ]
    end

    def charge_row_no_type
      %q[ 89, 2006-12-30, XX, 0, 50.5, S ] +
      %q[ 24, 3, 25, 6, 25, 9, 31, 12 ] +
      %q[ 1901-01-01, 0 ]
    end

    def charge_row_invalid_due_in
      %q[ 89, 2006-12-30, GR, X, 50.5, S ] +
      %q[ 24, 3, 25, 6, 25, 9, 31, 12 ] +
      %q[ 1901-01-01, 0 ]
    end


  end
end