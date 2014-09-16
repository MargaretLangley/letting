require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in admin_attributes
    sheet_create id: 1,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Bell',
                 phone: '01710008',
                 vat: '89',
                 heading2: 'give you notice pursuant',
                 address: address_new(road: 'High')
  end

  context '#view' do
    it 'finds view page 1' do
      visit '/sheets/1'
      expect(page.title). to eq 'Letting - View Sheet'
      expect(page).to have_text 'Bell'
      expect(page).to have_text '01710008'
      expect(page).to have_text '89'
      expect(page).to have_text 'give you notice pursuant'
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
