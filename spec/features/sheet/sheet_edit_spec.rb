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

  context '#edit page 1' do
    it 'finds data on 1st page' do
      visit '/sheets/1/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      expect(find_field('VAT').value).to have_text '89'
      expect(find_field('Road').value).to have_text 'High'
    end

    it 'has views link' do
      visit '/sheets/1/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      click_on('View')
      expect(page.title). to eq 'Letting - View Sheet'
    end
  end

  context '#edit page 2' do
    it 'finds data on 2nd page and updates successfully' do
      sheet_create id: 2
      visit '/sheets/2/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      fill_in '2nd Heading', with: 'Bowled Out!'
      click_on 'Update Sheet'
      expect(page). to have_text /successfully updated!/i
    end

    it 'finds data on 2nd page and updates unsuccessfully' do
      sheet_create id: 2
      visit '/sheets/2/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      fill_in 'Invoice Name', with: ''
      click_on 'Update Sheet'
      expect(page).to have_css '[data-role="errors"]'
    end
  end
end
