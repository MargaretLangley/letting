require 'csv'
require 'rails_helper'
require_relative '../../lib/import/charge_row'
require_relative '../../lib/import/file_header'

####
#
# charge_structure_matcher_spec.rb
#
# unit testing for charge_structure_matcher
#
####
#
module DB
  describe ChargeStructureMatcher do
    context 'credit row' do
      let(:row) { ChargeRow.new parse_line charge_row }

      context 'methods' do
        it 'matches on charged_id and due_ons' do
          structure = ChargeStructure.new(id: 5)
          structure.build_charged_in(id: 1, name: 'arrears')
          structure.build_charge_cycle(id: 100, name: 'Anything')
          structure.due_ons.build day: 25, month: 3
          structure.due_ons.build day: 29, month: 9
          structure.save!
          expect(ChargeStructureMatcher.new(row).id).to eq 5
        end

        it 'requires the same charged_id to match' do
          structure = ChargeStructure.new(id: 5)
          structure.build_charged_in(id: 100, name: 'arrears')
          structure.build_charge_cycle(id: 100, name: 'Anything')
          structure.due_ons.build day: 25, month: 3
          structure.due_ons.build day: 29, month: 9
          structure.save!
          expect { ChargeStructureMatcher.new(row).id }.to \
            raise_error ChargeStuctureUnknown
        end

        it 'requires the same due_ons to match' do
          structure = ChargeStructure.new(id: 5)
          structure.build_charged_in(id: 1, name: 'arrears')
          structure.build_charge_cycle(id: 100, name: 'Anything')
          structure.due_ons.build day: 25, month: 3
          structure.save!
          expect { ChargeStructureMatcher.new(row).id }.to \
            raise_error ChargeStuctureUnknown
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

    def charge_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 25, 3, 29, 9, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end

    def charge_monthly_row
      %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
      %q( 24, 0, 0, 0, 0, 0, 0, 0, ) +
      %q( 1901-01-01, 0 )
    end
  end
end
