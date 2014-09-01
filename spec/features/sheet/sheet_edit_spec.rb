require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in
    sheet_create id: 1,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Bell',
                 phone: '01710008',
                 vat: '89',
                 heading2: 'give you notice pursuant'
  end

  context '#edit page 1' do
    it 'finds data on 1st page and updates successfully' do
      visit '/sheets/1/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      expect(find_field('VAT').value)
      .to have_text '89'
      fill_in 'Invoice Name', with: 'T Appleson'
      click_on 'Update Sheet'
      expect(page). to have_text /successfully updated!/i
    end
  end

  context '#edit page 2' do
    it 'finds data on 2nd page and updates successfully' do

      sheet_create id: 2,
                   description: 'Page 2',
                   invoice_name: 'Cook',
                   phone: '01719494',
                   vat: '9222',
                   heading2: 'Fill in'

      visit '/sheets/2/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      fill_in '2nd Heading', with: 'Bowled Out!'
      click_on 'Update Sheet'
      expect(page). to have_text /successfully updated!/i
    end
  end

end
