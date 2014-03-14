require 'spec_helper'

describe Sheet do
  before(:each) { log_in }

  context '#view' do
    it 'finds data ok' do
       sheet = sheet_factory
       visit "/sheets/#{sheet.id}"
      #  save_and_open_page
      #  expect(page).to have_title 'View Sheet'
      # # expect(page).to have_text 'Estates Ltd'
      # expect(page).to have_text 'Hillbank House'
    end
  end
end
