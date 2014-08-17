require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/credit_row'
# rubocop: disable Style/Documentation

module DB
  describe CreditRow, :import do
    let(:row) { CreditRow.new parse_line credit_row }

    describe 'readers' do
      it 'human_ref' do
        expect(row.human_ref).to eq '89'
      end

      it 'charge_code' do
        expect(row.charge_code).to eq 'GR'
      end

      it 'on_date' do
        expect(row.on_date).to eq '2012-03-25 12:00:00'
      end

      it 'has a negative amount' do
        expect(row.amount).to eq(-50.5)
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end

    def credit_row
      %q(89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0)
    end
  end
end
