require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do
    it 'basic' do
      log_in admin_attributes
      invoicing_create id: 1,
                       property_range: '1-100',
                       start_date: '2014/06/30',
                       end_date: '2014/08/30'

      visit '/invoicings/1'
      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-100'
      expect(page).to have_text '108'
    end
  end
end
