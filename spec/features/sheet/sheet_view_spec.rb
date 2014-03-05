require 'spec_helper'

describe Sheet do
  before(:each) { log_in admin_attributes }

  context '#view' do
    it 'finds data ok' do
      sheet = sheet_factory

      # TODO change visit to click on view
      #click_on 'View'
      visit "/sheets/#{sheet.id}"

      expect(page).to have_title 'View Sheet'
      expect(page).to have_text 'Estates Ltd'
      expect(page).to have_text 'Hillbank House'
    end
  end
end
