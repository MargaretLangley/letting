require 'rails_helper'

describe Invoicing, type: :feature do

  before(:each) do
    log_in admin_attributes
    invoicing_create property_range: '1-100',
                     start_date: '2014/06/30',
                     end_date: '2014/08/30'
  end

  describe '#index' do
    it 'basic' do
      visit '/invoicings/'
      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-100'
      expect(page).to have_text '30/06/2014'
    end

    it 'Invoicings latest start dates first' do
      invoicing_create property_range: '101-200',
                       start_date: '2014/07/10',
                       end_date: '2014/08/30'
      visit '/invoicings/'
      expect(page.title).to eq 'Letting - Invoicing'
      first(:link, 'View').click
      expect(page).to have_text '101-200'
    end
  end
end
