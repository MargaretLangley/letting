require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do
    it 'basic' do
      log_in admin_attributes
      invoicing_create id: 1,
                       property_range: '1-200',
                       period_first: '2014/06/30',
                       period_last: '2014/08/30'
      template_create id: 2
      visit '/prints/1'
      expect(page).to have_text 'VAT'
      expect(page).to have_text '108'
      expect(page).to_not have_text '1-200'
    end
  end
end
