require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/credit_row'

module DB
  describe CreditRow do

    let(:row) { CreditRow.new parse_line credit_row }

    context 'readers' do

      it 'human_ref' do
        expect(row.human_ref).to eq '89'
      end

      it 'charge_code' do
        expect(row.charge_code).to eq 'GR'
      end

      it 'on_date' do
        expect(row.on_date).to eq '2012-03-25 12:00:00'
      end

      it 'amount' do
        expect(row.amount).to eq 50.5
      end

    end

    context 'methods' do

      context '#ChargeType' do

        it 'returns valid' do
          expect(row.charge_type).to eq 'Ground Rent'
        end

        it 'errors invalid' do
          bad_code = CreditRow.new parse_line credit_row_no_type
          expect { bad_code.charge_type }.to raise_error ChargeCodeUnknown
        end

      end

      context '#account_id' do
        it 'returns valid' do
          property = property_create! human_ref: 89
          expect(row.account_id).to eq property.account.id
        end
        it 'errors invalid' do
          expect{ row.account_id }.to raise_error PropertyRefUnknown
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

    def credit_row
      %q[89, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end

    def credit_row_no_type
      %q[89, XX, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0]
    end
  end
end
