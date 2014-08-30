require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/charge_row'

####
#
# charge_row_spec.rb
#
# unit testing for charge_row
#
# ChargeRow wraps up acc_info.csv rows - used by ImportCharge
#
####
module DB
  describe ChargeRow, :import do
    describe 'credit row' do
      let(:row) { ChargeRow.new parse_line base_charge_row }

      describe 'attribute' do
        it('amount') { expect(row.amount).to eq 50.5 }
      end

      describe 'methods' do

        describe '#charge_type' do
          it('returns valid') { expect(row.charge_type).to eq 'Ground Rent' }

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_no_type
            expect { bad_code.charge_type }.to raise_error ChargeCodeUnknown
          end
        end

        describe '#charged_in_id' do
          it('returns valid id') { expect(row.charged_in_id).to eq 1 }

          it 'overridden return for advance only charges' do
            row = ChargeRow.new parse_line insurance_row
            expect(row.charged_in_id).to eq 2
          end

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_invalid_charged_in
            expect { bad_code.charged_in_id }
              .to raise_error ChargedInCodeUnknown
          end
        end

        describe '#charge_cycle_id' do
          it('returns valid id') do
            charge_cycle_create id: 3, due_on: DueOn.new(day: 25, month: 3)
            expect(row.charge_cycle_id).to eq 3
          end

          it 'messages when no charge cycles' do
            expect($stdout).to receive(:puts)
              .with(/ChargeCycle table has no records/)
            row.charge_cycle_id
          end

          it 'messages on unknown cycle' do
            charge_cycle_create id: 3, due_on: DueOn.new(day: 10, month: 10)
            expect($stdout).to receive(:puts)
              .with(/charge row does not match a charge cycle/)
            row.charge_cycle_id
          end
        end

        describe '#day_months' do
          it 'creates day and months' do
            row = ChargeRow.new parse_line base_charge_row
            expect(row.day_months).to eq [[25, 3]]
          end

          it 'produces elements until empty' do
            expect(ChargeRow.new(parse_line(base_charge_row)).day_months.count)
              .to eq 1
          end

          it 'yields quarter year charges' do
            quarter_charge_row = \
            %q( 89, , GR, 0, 5, S, 24, 3, 25, 6, 25, 9, 31, 12, , 0)
            expect(ChargeRow.new(parse_line(quarter_charge_row))
                            .day_months.count)
              .to eq 4
          end

          it 'always yields two values for half year charges' do
            row = ChargeRow.new parse_line half_charge_row_with_4_charges
            expect(row.day_months.count).to eq 2
          end

          it 'creates monthly day and months' do
            row = ChargeRow.new parse_line charge_monthly_row
            expect(row.day_months.count).to eq 12
            expect(row.day_months[0..1]).to eq [[24, 1], [24, 2]]
          end

          it 'invalid code for maximum dates throws error' do
            row = ChargeRow.new parse_line(charge_row_no_type)
            expect { row.day_months }.to raise_error ChargeCodeUnknown
          end
        end

        it 'returns expected attributes' do
          expect(row.attributes[:charge_type]).to eq 'Ground Rent'
          expect(row.attributes[:amount]).to eq 50.5
          expect(row.attributes[:start_date].to_s).to eq '2000-01-01'
          expect(row.attributes[:end_date].to_s).to eq '2100-01-01'
        end

      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.charge,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                     )
    end

    def base_charge_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 25, 3, 0, 0, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_monthly_row
      %q( 89, 2006-12-30, M, 0, 50.5, S, ) +
      %q( 24, 7, 20, 12, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_row_no_type
      %q( 89, 2006-12-30, XX, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 25, 9, 31, 12, ) +
      %q( 1901-01-01, 0 )
    end

    def insurance_row
      %q( 89, 2006-12-30, Ins, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def half_charge_row_with_4_charges
      %q( 89, 2006-12-30, H, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 1, 1, 2, 2, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_row_invalid_charged_in
      %q( 89, 2006-12-30, GR, X, 50.5, S, ) +
      %q( 24, 3, 25, 6, 25, 9, 31, 12, ) +
      %q( 1901-01-01, 0 )
    end
  end
end
