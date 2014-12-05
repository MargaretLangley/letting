require 'rails_helper'

describe Invoicing, type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  describe '#index' do
    it 'basic' do
      invoicing_create property_range: '1-200',
                       period_first: '2013/06/30',
                       period_last: '2013/08/30'
      visit '/invoicings/'

      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-200'
      expect(page).to have_text '30/Jun/13'
    end

    it 'deletes' do
      invoicing_create property_range: '1-200',
                       period_first: '2014/06/30',
                       period_last: '2014/08/30'
      visit '/invoicings/'

      expect { click_on 'Delete' }.to change(Invoicing, :count)
      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to \
        have_text 'Range 1-200, period: 30/Jun - 30/Aug deleted!'
    end
  end

end
