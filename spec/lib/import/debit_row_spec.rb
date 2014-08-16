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
  describe DebitRow do
    let(:row) { DebitRow.new parse_line debit_row }

    it 'has human_ref' do
      expect(row.human_ref).to eq '2002'
    end

    it 'calculates amount' do
      expect(row.amount).to eq 50.5
    end

    context 'negative credit' do
      it 'calculates amount from negative credit' do
        row = DebitRow.new parse_line debit_negative_credit
        expect(row.amount).to eq 10.5
      end
    end

    it 'rows attributes are returned' do
      charge_structure_create
      charge_id = property_with_charge_create.account.charges.first.id
      expect(row.attributes[:charge_id]).to eq charge_id
      expect(row.attributes[:on_date]).to eq '2012-03-25 12:00:00'
      expect(row.attributes[:amount]).to eq 50.5
      expect(row.attributes[:debit_generator_id]).to eq(-1)
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end

    def debit_row
      %q(2002, GR, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0)
    end

    def debit_negative_credit
      %q(2002, GR, 2012-03-25 12:00:00, Ground Rent, 0, -10.5, 0)
    end
  end
end
