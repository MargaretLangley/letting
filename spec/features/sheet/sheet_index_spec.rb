require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in
    sheet_create id: 1,
                 description: 'Page 1 Invoice',
                 invoice_name: 'Morgan',
                 phone: '01710008',
                 vat: '89',
                 heading2: 'give you notice pursuant'

    visit '/sheets/'

  end

  context '#index' do

    it 'checks data' do
      expect(page).to have_title 'Letting - Sheet'
      expect(page).to have_text 'Page 1 Invoice'
      expect(page).to have_link 'Edit'
    end

    it 'has edit link' do
      click_on 'Edit'
      expect(page.title).to eq 'Letting - Edit Sheet'
    end

    # Needs show page fixing
    # it 'has view link' do
    #   click_on 'View'
    #   expect(page.title).to eq 'Letting - View Sheet'
    # end
  end

end
