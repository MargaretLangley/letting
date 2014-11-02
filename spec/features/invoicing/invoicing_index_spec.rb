require 'rails_helper'

describe Invoicing, type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  describe '#index' do
    it 'basic' do
      invoicing_create property_range: '1-200',
                       period_first: '2014/06/30',
                       period_last: '2014/08/30'
      visit '/invoicings/'

      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-200'
      expect(page).to have_text '30/Jun/14'
    end

    it 'has view link' do
      invoicing_create property_range: '1-200',
                 period_first: '2014/06/30',
                 period_last: '2014/08/30'
      visit '/invoicings/'

      first(:link, 'View').click
      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-200'
      expect(page).to have_text '30/Jun/14'
    end

  end
end
