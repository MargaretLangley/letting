require 'rails_helper'

describe 'InvoiceText View', type: :feature do

  before(:each) do
    log_in admin_attributes
    invoice_text_create id: 1,
                        address: address_new(road: 'High')
  end

  context '#view' do
    it 'finds view 1st page' do
      visit '/invoice_texts/1'
      expect(page.title). to eq 'Letting - View Invoice Text'
    end

    it 'finds vat' do
      visit '/invoice_texts/1'
      expect(page).to have_text '89'
    end

    it 'finds address' do
      visit '/invoice_texts/1'
      expect(page).to have_text 'High'
    end

    it 'has edit link' do
      visit '/invoice_texts/1'
      expect(page.title).to eq 'Letting - View Invoice Text'
      click_on('Edit')
      expect(page.title).to eq 'Letting - Edit Invoice Text'
    end
  end
end
