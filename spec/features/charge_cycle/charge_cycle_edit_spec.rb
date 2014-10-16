require 'rails_helper'

require_relative '../../support/pages/charge_cycle_page'

describe 'ChargeCycle Edit', :ledgers, type: :feature do
  before { log_in admin_attributes }

  context 'Term' do
    it 'edits term' do
      charge_cycle_create id: 1,
                          name: 'Jan/July',
                          order: 11,
                          cycle_type: 'term',
                          due_ons: [DueOn.new(day: 6, month: 10)]
      cycle_page = ChargeCyclePage.new type: :term, action: :edit

      cycle_page.enter
      expect(page.title).to eq 'Letting - Edit Charge Cycles'
      cycle_page.name = 'April/Nov'
      cycle_page.order = '44'
      cycle_page.due_on(day: 10, month: 2)
      cycle_page.do 'Update Charge Cycle'
      expect(cycle_page).to be_success
    end
  end

  context 'Monthly' do
    it 'edits monthly' do
      charge_cycle_create id: 1,
                          name: 'Regular',
                          order: 22,
                          cycle_type: 'monthly',
                          due_ons: [DueOn.new(day: 8, month: 1)]
      cycle_page = ChargeCyclePage.new type: :monthly, action: :edit

      cycle_page.enter
      expect(page).to have_text 'Monthly'
      cycle_page.name = 'New Monthly'
      cycle_page.order = '21'
      cycle_page.due_on day: 12, month: 0
      cycle_page.do 'Update Charge Cycle'
      expect(cycle_page).to be_success
    end
  end

  it 'aborts on Cancel' do
    charge_cycle_create id: 1
    cycle_page = ChargeCyclePage.new action: :edit

    cycle_page.enter
    cycle_page.do 'Cancel'
    expect(page.title).to eq 'Letting - Charge Cycles'
  end

  it 'can error' do
    charge_cycle_create id: 1, name: 'Jan/July'

    cycle_page = ChargeCyclePage.new action: :edit
    cycle_page.enter
    cycle_page.name = ''
    cycle_page.do 'Update Charge Cycle'
    expect(cycle_page).to be_errored
  end
end
