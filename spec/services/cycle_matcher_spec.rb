require 'csv'
require 'rails_helper'
require_relative '../../lib/import/file_header'
require_relative '../../lib/import/charges/charge_row'

####
#
# cycle_matcher_spec.rb
#
# unit testing for cycle_matcher
#
####
#
module DB
  describe CycleMatcher, :cycle do
    it 'matches on due_ons' do
      charged_in = charged_in_create(id: 1, name: 'Arrears')
      cycle = Cycle.new(id: 100,
                        name: 'Anything',
                        charged_in_id: charged_in.id,
                        order: 5,
                        cycle_type: 'term')
      cycle.due_ons.build day: 25, month: 3
      cycle.due_ons.build day: 29, month: 9
      cycle.save!
      day_months = [[25, 3], [29, 9]]
      cm = CycleMatcher.new charged_in_id: charged_in.id, day_months: day_months
      expect(cm.id).to eq 100
    end

    it 'distinct when due_ons different' do
      charged_in = charged_in_create(id: 1, name: 'Arrears')
      cycle = Cycle.new(id: 100,
                        name: 'Anything',
                        charged_in_id: charged_in.id,
                        order: 5,
                        cycle_type: 'term')
      cycle.due_ons.build day: 19, month: 3
      cycle.save!
      day_months = [[25, 3]]
      expect do
        CycleMatcher.new(charged_in_id: charged_in.id,
                         day_months: day_months).id
      end.to raise_error CycleUnknown
    end
  end
end
