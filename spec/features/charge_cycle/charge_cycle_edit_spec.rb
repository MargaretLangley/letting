require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    visit '/charge_cycles/#{1}/edit'
  end

  context '#index' do

    it 'basic' do
       expect(page).to have_text 'Edit'
    end

  end
end
