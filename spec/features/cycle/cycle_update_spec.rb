require 'rails_helper'

require_relative '../../support/pages/cycle_page'

describe 'Cycle Update', :ledgers, type: :feature do
  before { log_in admin_attributes }

  context 'Term' do
    it 'edits term' do
      cycle_create id: 1,
                   name: 'Jan/July',
                   charged_in: charged_in_create(id: 1, name: 'Arrears'),
                   order: 11,
                   cycle_type: 'term',
                   due_ons: [DueOn.new(day: 6, month: 10)]
      cycle_page = CyclePage.new type: :term, action: :edit

      cycle_page.enter
      expect(page.title).to eq 'Letting - Edit Cycle'
      cycle_page.name = 'April/Nov'
      cycle_page.choose 'Arrears'
      cycle_page.order = '44'
      cycle_page.due_on(day: 10, month: 2)
      cycle_page.do 'Update Cycle'
      expect(cycle_page).to be_success
    end
  end

  context 'Monthly' do
    it 'edits monthly' do
      cycle_create id: 1,
                   name: 'Regular',
                   charged_in: charged_in_create(id: 1, name: 'Arrears'),
                   order: 22,
                   cycle_type: 'monthly',
                   due_ons: [DueOn.new(day: 8, month: 1)]
      cycle_page = CyclePage.new type: :monthly, action: :edit

      cycle_page.enter
      expect(page).to have_text 'Monthly'
      cycle_page.name = 'New Monthly'
      cycle_page.choose 'Arrears'
      cycle_page.order = '21'
      cycle_page.due_on day: 12, month: 0
      cycle_page.do 'Update Cycle'
      expect(cycle_page).to be_success
    end
  end

  it 'aborts on Cancel' do
    cycle_create id: 1
    cycle_page = CyclePage.new action: :edit

    cycle_page.enter
    cycle_page.do 'Cancel'
    expect(page.title).to eq 'Letting - Cycles'
  end

  it 'can error' do
    cycle_create id: 1, name: 'Jan/July'

    cycle_page = CyclePage.new action: :edit
    cycle_page.enter
    cycle_page.name = ''
    cycle_page.do 'Update Cycle'
    expect(cycle_page).to be_errored
  end
end
