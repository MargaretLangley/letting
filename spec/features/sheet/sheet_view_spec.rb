require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in admin_attributes
    sheet_create id: 1,
                 address: address_new(road: 'High')
  end

  context '#view' do
    it 'finds view page 1' do
      visit '/sheets/1'
      expect(page.title). to eq 'Letting - View Sheet'
    end

    it 'finds address' do
      visit '/sheets/1'
      expect(page).to have_text 'High'
    end

    it 'has edit link' do
      visit '/sheets/1'
      expect(page.title). to eq 'Letting - View Sheet'
      click_on('Edit')
      expect(page.title). to eq 'Letting - Edit Sheet'
    end
  end
end
