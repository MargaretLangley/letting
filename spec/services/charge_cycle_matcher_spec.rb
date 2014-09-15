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
    it 'matches on due_ons' do
      cycle = ChargeCycle.new(id: 100,
                              name: 'Anything',
                              order: 5,
                              period_type: 'term')
      cycle.due_ons.build day: 25, month: 3
      cycle.due_ons.build day: 29, month: 9
      cycle.save!
      day_months = [[25, 3], [29, 9]]
      expect(ChargeCycleMatcher.new(day_months: day_months).id).to eq 100
    end

    it 'distinct when due_ons different' do
      cycle = ChargeCycle.new(id: 100,
                              name: 'Anything',
                              order: 5,
                              period_type: 'term')
      cycle.due_ons.build day: 19, month: 3
      cycle.save!
      day_months = [[25, 3]]
      expect { ChargeCycleMatcher.new(day_months: day_months).id }.to \
        raise_error ChargeCycleUnknown
    end
  end
end
