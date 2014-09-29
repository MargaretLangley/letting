require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/debit_row'

####
#
# debit_row_spec.rb
#
# unit testing for debit_row
#
####
#
module DB
  describe DebitRow, :import do
    it 'has human_ref' do
      row = DebitRow.new parse_line debit_row
      expect(row.human_ref).to eq '2002'
    end

    it 'calculates amount' do
      row = DebitRow.new parse_line debit_row
      expect(row.amount).to eq 50.5
    end

    context 'negative credit' do
      it 'calculates amount from negative credit' do
        row = DebitRow.new parse_line debit_negative_credit
        expect(row.amount).to eq 10.5
      end
    end

    it 'rows attributes are returned' do
      row = DebitRow.new parse_line debit_row
      charge = charge_new charge_type: 'Insurance'
      property_create account: account_new(charge: charge)
      expect(row.attributes[:charge_id]).to eq charge.id
      expect(row.attributes[:on_date]).to eq '2012-03-25 12:00:00'
      expect(row.attributes[:amount]).to eq 50.5
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end

    def debit_row
      %q(2002, Ins, 2012-03-25 12:00:00, Insurance, 50.5, 0, 0)
    end

    def debit_negative_credit
      %q(2002, GR, 2012-03-25 12:00:00, Ground Rent, 0, -10.5, 0)
    end
  end
end
