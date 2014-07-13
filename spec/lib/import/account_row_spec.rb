require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/account_row'

module DB
  describe AccountRow do
    let(:credit_row) { AccountRow.new parse_line credit_string }
    let(:debit_row) { AccountRow.new parse_line debit_string }

    context 'credit row' do

      context 'attributes' do
        it 'has human_ref' do
          expect(credit_row.human_ref).to eq 2002
        end

        it 'has charge_code' do
          expect(credit_row.charge_code).to eq 'GR'
        end
      end

      context 'methods' do
        context '#credit?' do
          it 'returns true when credit row' do
            expect(credit_row).to be_credit
          end

          it 'returns false when debit row' do
            expect(debit_row).to_not be_credit
          end
        end

        context '#debit?' do
          it 'returns true when debit row' do
            expect(debit_row).to be_debit
          end

          it 'returns true when credit paid negative' do
            credit_row = AccountRow.new parse_line credit_negative
            expect(credit_row).to be_debit
          end

          it 'returns false when credit row' do
            expect(credit_row).to_not be_debit
          end
        end

        context '#amount' do
          it 'returns debit column when debit row' do
            expect(debit_row.amount).to eq 60.5
          end

          it 'returns credit column when credit row' do
            expect(credit_row.amount).to eq 50.5
          end
        end

        context '#balance?' do
          let(:blance_row) { AccountRow.new parse_line balance }
          def balance
            %q(122, Bal, 2011-08-01 00:00:00, ,                  0,    0,    0)
          end

          it 'returns true when balance row' do
            expect(blance_row).to be_balance
          end

          it 'returns false when credit row' do
            expect(credit_row).to_not be_balance
          end
        end

        context '#account_id' do
          it 'finds account_id' do
            property = property_create!
            expect(credit_row.account_id).to eq property.account.id
          end

          it 'errors if property unknown' do
            expect { credit_row.account_id }.to raise_error PropertyRefUnknown
          end
        end

        context 'on_date' do
          it 'returns date' do
            expect(credit_row.on_date).to eq Date.new 2012, 3, 25
          end
          it 'handles bad date' do
            bad_date = AccountRow.new parse_line bad_date_string
            expect { bad_date.on_date }.to raise_error ArgumentError
          end
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

    def credit_string
      %q(2002, GR, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0)
    end

    def debit_string
      %q(89, GR, 2012-03-25 12:00:00, Ground Rent, 60.5, 0, 0)
    end

    def credit_row_no_type
      %q(89, Bal, 2012-03-25 12:00:00, Ground Rent, 0, 50.5, 0)
    end

    def credit_negative
      %q(2002, GR, 2012-03-25 12:00:00, Ground Rent, 0, -10.5, 0)
    end

    def bad_date_string
      %q(2002, GR, d-0x-dd, Ground Rent, 0, 50.5, 0)
    end
  end
end
