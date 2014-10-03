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
    def charge_row code: 'GR', charged_in: 0, month: 3, day: 25
      %(89, 2006-12-30, #{code}, #{charged_in}, 50.5, S,) +
      %(#{day}, #{month}, 0, 0, 0, 0, 0, 0,) +
      %(1901-01-01, 0)
    end
    describe 'attribute' do
      it('amount') do
        expect(ChargeRow.new(parse_line charge_row).amount).to eq 50.5
      end
    end

    describe 'methods' do

      describe '#charge_type' do
        it 'returns' do
          expect(ChargeRow.new(parse_line charge_row).charge_type)
            .to eq 'Ground Rent'
        end
        it 'errors invalid' do
          bad_type = ChargeRow.new parse_line charge_row code: 'BAD'
          expect { bad_type.charge_type }.to raise_error ChargeCodeUnknown
        end
      end

      describe '#charged_in_id' do
        it 'returns valid id' do
          expect(ChargeRow.new(parse_line charge_row(charged_in: 0)).charged_in_id)
            .to eq 1
        end

        # insurance must have an advance charged_in - think about it ;-)
        it 'overrides when charge must be in advance' do
          row = ChargeRow.new parse_line charge_row(code: 'Ins', charged_in: 0)
          expect(row.charged_in_id).to eq 2
        end

        it 'errors on invalid' do
          row = ChargeRow.new parse_line charge_row(charged_in: 'BAD')
          expect { row.charged_in_id }.to raise_error ChargedInCodeUnknown
        end
      end

      describe '#charge_cycle_id' do
        it 'returns valid id' do
          charge_cycle_create id: 3, due_ons: [DueOn.new(month: 3, day: 25)]
          row = ChargeRow.new parse_line charge_row month: 3, day: 25
          expect(row.charge_cycle_id).to eq 3
        end

        it 'messages when no charge cycles' do
          row = ChargeRow.new parse_line charge_row month: 3, day: 25
          expect { warn 'ChargeCycle table has no records' }.to output.to_stderr
          row.charge_cycle_id
        end

        it 'messages on unknown cycle' do
          charge_cycle_create id: 3, due_ons: [DueOn.new(month: 10, day: 10)]
          row = ChargeRow.new parse_line charge_row(month: 3, day: 25)
          expect { warn 'charge row does not match a charge cycle' }
            .to output.to_stderr
          row.charge_cycle_id
        end
      end

      describe '#day_months' do
        it 'creates day and months' do
          row = ChargeRow.new parse_line charge_row month: 3, day: 25
          expect(row.day_months).to eq [[25, 3]]
        end

        describe 'produces day month pairs' do
          it 'stops on empty due date (0,0)' do
            charge_row = %q(9,, GR, 0, 5.5, S, 1, 1, 0, 0, 0, 0, 0, 0,, 0)
            expect(ChargeRow.new(parse_line(charge_row)).day_months.count)
              .to eq 1
          end

          # A few properties (e.g. 7022 have 0, -1 as empty due date)
          it 'stops on empty due date (0,-1)' do
            charge_row = %q(9,, GR, 0, 5.5, S, 1, 1, 0, -1, 0, 0, 0, 0,, 0)
            expect(ChargeRow.new(parse_line(charge_row)).day_months.count)
              .to eq 1
          end
        end

        it 'maximum day month pairs of 4' do
          quarter_charge = %q(9,, GR, 0, 5, S, 1, 1, 2, 2, 3, 3, 4, 4,, 0)
          expect(ChargeRow.new(parse_line quarter_charge).day_months.count)
            .to eq 4
        end

        it 'always receive two values for half year charges' do
          h_charge_with_4_charge_dates = \
            %q(9,, H, 0, 5.5, S, 1, 1, 2, 2, 3, 3, 4, 4,, 0)
          row = ChargeRow.new parse_line h_charge_with_4_charge_dates
          expect(row.day_months.count).to eq 2
        end

        it 'creates monthly day and months' do
          monthly = %q(9,, M, 0, 5.5, S, 24, 0, 0, 0, 0, 0, 0, 0,, 0)
          row = ChargeRow.new parse_line monthly
          expect(row.day_months.count).to eq 12
          expect(row.day_months[0..1]).to eq [[24, 1], [24, 2]]
        end
      end

      it 'returns expected attributes' do
        row = ChargeRow.new parse_line charge_row
        expect(row.attributes[:charge_type]).to eq 'Ground Rent'
        expect(row.attributes[:amount]).to eq 50.5
        expect(row.attributes[:start_date].to_s).to eq '2000-01-01'
        expect(row.attributes[:end_date].to_s).to eq '2100-01-01'
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.charge,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                     )
    end
  end
end
