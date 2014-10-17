require 'rails_helper'

require_relative '../../support/pages/cycle_page'

describe Cycle, :ledgers, type: :feature do
  before(:each) { log_in admin_attributes }

  context 'Term' do
    it 'creates a charge cycle' do
      charged_in_create id: 2, name: 'Advance'
      cycle_page = CyclePage.new type: :term, action: :create
      cycle_page.enter
      expect(page.title).to eq 'Letting - New Charge Cycles'
      cycle_page.name = 'April/Nov'
      cycle_page.order = '44'
      cycle_page.due_on day: 10, month: 2
      cycle_page.association advance: true
      cycle_page.do 'Create Charge Cycle'
      expect(cycle_page).to be_success
    end

    it 'displays form errors' do
      cycle_page = CyclePage.new type: :term, action: :create
      cycle_page.enter
      cycle_page.do 'Create Charge Cycle'
      expect(cycle_page).to be_errored
    end
  end

  context 'Monthly' do
    it 'creates a charge cycle' do
      charged_in_create id: 1, name: 'Arrears'
      cycle_page = CyclePage.new type: :monthly, action: :create
      cycle_page.enter
      expect(page.title).to eq 'Letting - New Charge Cycles'
      cycle_page.name = 'Monthly'
      cycle_page.order = '44'
      cycle_page.due_on day: 10, month: 0
      cycle_page.association arrears: true
      cycle_page.do 'Create Charge Cycle'
      expect(cycle_page).to be_success
    end

    it 'displays form errors' do
      cycle_page = CyclePage.new type: :monthly, action: :create
      cycle_page.enter
      cycle_page.do 'Create Charge Cycle'
      expect(cycle_page).to be_errored
    end
  end
end
