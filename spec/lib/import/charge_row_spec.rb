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
####
module DB
  describe ChargeRow do
    describe 'credit row' do
      let(:row) { ChargeRow.new parse_line quarter_charge_row }

      describe 'attribute' do
        it('amount') { expect(row.amount).to eq 50.5 }
      end

      describe 'methods' do
        describe '#monthly_charge?' do
          it 'true for monthly' do
            monthly = ChargeRow.new parse_line charge_monthly_row
            expect(monthly.monthly_charge?).to be true
          end
          it 'false for on dated' do
            expect(row.monthly_charge?).to be false
          end
        end

        describe '#charge_type' do
          it('returns valid') { expect(row.charge_type).to eq 'Ground Rent' }

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_no_type
            expect { bad_code.charge_type }.to raise_error ChargeCodeUnknown
          end
        end

        describe '#maximum_dates' do
          it('returns valid') { expect(row.maximum_dates).to eq 4 }

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_no_type
            expect { bad_code.maximum_dates }.to raise_error ChargeCodeUnknown
          end
        end

        describe '#charged_in_id' do
          it('returns valid') { expect(row.charged_in_id).to eq 1 }

          it 'errors invalid' do
            bad_code = ChargeRow.new parse_line charge_row_invalid_due_in
            expect { bad_code.charged_in_id }.to raise_error DueInCodeUnknown
          end
        end

        describe '#charge_strucutre_id' do
          it('returns valid') do
            row = ChargeRow.new parse_line half_charge_row
            structure = ChargeStructure.new(id: 5)
            structure.build_charged_in(id: 1, name: 'arrears')
            structure.build_charge_cycle(id: 100, name: 'Anything')
            structure.due_ons.build day: 24, month: 3
            structure.due_ons.build day: 25, month: 6
            structure.save!
            expect(row.charge_structure_id).to eq 5
          end

          it 'errors invalid' do
            expect($stdout).to receive(:puts).with(/charge row does not/)
            charge_structure_create
            row = ChargeRow.new parse_line quarter_charge_row
            row.charge_structure_id
          end
        end

        describe 'iterates' do
          it 'yields quarter year charges' do
            yielded_values = []
            row.each do |day, month|
              yielded_values << [day, month]
            end
            expect(yielded_values).to eq [[24, 3], [25, 6], [25, 9], [31, 12]]
          end

          it 'yields half year charges' do
            row = ChargeRow.new parse_line half_charge_row
            yielded_values = []
            row.each do |day, month|
              yielded_values << [day, month]
            end
            expect(yielded_values).to eq [[24, 3], [25, 6]]
          end

          it 'yields month charges' do
            skip 'Need month charge to be defined ... if anything?'
            # row = ChargeRow.new parse_line charge_monthly_row
            # yielded_values = []
            # row.each do |day, month|
            #   yielded_values << [day, month]
            # end
            # expect(yielded_values).to eq [[24, 3]]
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

    def quarter_charge_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 25, 9, 31, 12, ) +
      %q( 1901-01-01, 0 )
    end

    def half_charge_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_monthly_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 24, 0, 0, 0, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_row_no_type
      %q( 89, 2006-12-30, XX, 0, 50.5, S, ) +
      %q( 24, 3, 25, 6, 25, 9, 31, 12, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_row_invalid_due_in
      %q( 89, 2006-12-30, GR, X, 50.5, S, ) +
      %q( 24, 3, 25, 6, 25, 9, 31, 12, ) +
      %q( 1901-01-01, 0 )
    end
  end
end
