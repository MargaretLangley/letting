require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create id: 70
    charge_cycle_create name: 'Jan/July'
    charge_cycle_create order: 1
  end

  context '#index' do
    # it 'basic' do
    #    expect(page).to have_text 'Edit'
    # end

  end
end
