require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/credit_row'
# rubocop: disable Style/Documentation

module DB
  describe CreditRow, :import do
    describe 'row' do
      let(:row) { CreditRow.new parse_line credit_row }
      def credit_row
        %q(9, GR, 2012-03-25 12:00:00, Ground Rent, 0, 5.5, 0)
      end

      it('human_ref') { expect(row.human_ref).to eq '9' }
      it('charge_code') { expect(row.charge_code).to eq 'GR' }
      it('on_date') { expect(row.on_date).to eq '2012-03-25 12:00:00' }
      it('negates amount') { expect(row.amount).to eq(-5.5) }
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
