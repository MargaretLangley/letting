require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create id: 1
    charge_cycle_create name: 'Jan/July'
    charge_cycle_create order: 1
    visit '/charge_cycles/'
  end

  context '#index' do

    it 'basic' do
      expect(current_path).to eq '/charge_cycles/'
      expect(page).to have_text 'Jan/July'
      expect(page).to have_text '1'
    end

    it 'has edit link' do
      expect(page).to have_link 'Edit'
    end

  end
end
