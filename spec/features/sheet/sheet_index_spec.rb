require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in
    sheet_create id: 2,
                 description: 'Page 2',
                 invoice_name: 'Morgan',
                 phone: '01710008',
                 vat: '89',
                 heading2: 'give you notice pursuant'
  end

  context '#index' do

    it 'checks data' do
      visit '/sheets/'
      expect(page).to have_title 'Letting - Sheet'
      expect(page).to have_text 'Page 2'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'View'
    end

    it 'has edit link' do
      visit '/sheets/'
      click_on 'Edit'
      expect(page.title).to eq 'Letting - Edit Sheet'
    end

    it 'has ordered list' do
      sheet_create id: 1,
                   description: 'Page 1',
                   invoice_name: 'Morgan',
                   phone: '01710008',
                   vat: '89',
                   heading2: 'give you notice pursuant'
      visit '/sheets/'
      first(:link, 'Edit').click
      expect(page).to have_text 'Page 1'
      expect(find_field('Invoice Name').value).to have_text 'Morgan'
    end
  end
end
