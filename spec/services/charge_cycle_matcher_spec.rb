require 'csv'
require 'rails_helper'
require_relative '../../lib/import/charge_row'
require_relative '../../lib/import/file_header'

####
#
# charge_cycle_matcher_spec.rb
#
# unit testing for charge_cycle_matcher
#
####
#
module DB
  describe ChargeCycleMatcher do
    context 'credit row' do
      let(:row) { ChargeRow.new parse_line mar_sep_charge_row }

      it 'matches on due_ons' do
        cycle = ChargeCycle.new(id: 100, name: 'Anything')
        cycle.due_ons.build day: 25, month: 3
        cycle.due_ons.build day: 29, month: 9
        cycle.save!
        expect(ChargeCycleMatcher.new(row).id).to eq 100
      end

      it 'distinct when due_ons different' do
        cycle = ChargeCycle.new(id: 100, name: 'Anything')
        cycle.due_ons.build day: 25, month: 3
        cycle.due_ons.build day: 31, month: 12
        cycle.save!
        expect { ChargeCycleMatcher.new(row).id }.to \
          raise_error ChargeCycleUnknown
      end

      def parse_line row_string
        CSV.parse_line(row_string,
                       headers: FileHeader.charge,
                       header_converters: :symbol,
                       converters: -> (field) { field ? field.strip : nil }
                     )
      end

      def mar_sep_charge_row
        %q( 89, 2006-12-30, GR, 0, 50.5, S, ) +
        %q( 25, 3, 29, 9, 0, 0, 0, 0, ) +
        %q( 1901-01-01, 0 )
      end
    end
  end
end
