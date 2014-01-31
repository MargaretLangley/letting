require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/debit_row'

module DB
  describe DebitRow do
    let(:row) { DebitRow.new parse_line debit_row }

    context 'attributes' do

      it 'has human_ref' do
        expect(row.human_ref).to eq '2002'
      end

      it 'calculates amount' do
        expect(row.amount).to eq 50.5
      end

      it 'calculates amount from negative credit' do
        row = DebitRow.new parse_line debit_negative_credit
        expect(row.amount).to eq 10.5
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

      context '#charge_id' do
        it 'returns valid charge_id' do
          property = property_with_charge_create!
          expect(row.charge_id).to eq property.account.charges.first.id
        end
        it 'errors if property unknown' do
          expect { row.charge_id }.to raise_error PropertyRefUnknown
        end
        it 'errors if charge unknown' do
          property_create!
          expect { row.charge_id }.to raise_error ChargeUnknown
        end
      end

      context 'attributes' do
        it 'returns expected attributes' do
          charge_id = property_with_charge_create!.account.charges.first.id
          expect(row.attributes[:charge_id]).to eq charge_id
          expect(row.attributes[:on_date]).to eq '2012-03-25 12:00:00'
          expect(row.attributes[:amount]).to eq 50.5
          expect(row.attributes[:debit_generator_id]).to eq(-1)
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (f) { f ? f.strip : nil }
                    )
    end

    def debit_row
      %q[2002, GR, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0]
    end

    def debit_negative_credit
      %q[2002, GR, 2012-03-25 12:00:00, Ground Rent, 0, -10.5, 0]
    end

    def debit_row_no_type
      %q[89, XXX, 2012-03-25 12:00:00, Ground Rent, 50.5, 0, 0]
    end

  end
end
