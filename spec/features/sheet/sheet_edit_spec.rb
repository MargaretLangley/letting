require 'spec_helper'

describe Sheet do
  before(:each) { log_in admin_attributes }

  context '#edit' do
    it 'finds data ok' do
      sheet = sheet_factory

      # TODO change visit to click on edit
      #click_on 'View'
      visit "/sheets/#{sheet.id}/edit"

      expect(page).to have_title 'Edit Sheet'
      expect(find_field('Invoice Name').value).to have_text 'Estates Ltd'
      expect(find_field('House name').value).to have_text 'Hillbank House'
    end
  end

end

