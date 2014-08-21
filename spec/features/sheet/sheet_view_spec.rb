require 'rails_helper'

describe Sheet, type: :feature do
  before(:each) { log_in }

  context '#view' do
    it 'finds data ok' do
      sheet = sheet_factory
      visit "/sheets/#{sheet.id}"
      expect(page).to have_text 'Estates Ltd'
    end
  end

  context '#view' do
    it 'finds data page 2 & goes to edit page' do
      sheet_factory
      sheet2 = sheet2_factory
      visit "/sheets/#{sheet2.id}"
      expect(page).to have_text 'Estates Ltd'
      expect(page).to have_text 'Page2 head1'
      click_on('Edit')
      expect(find_field('1st Text Block').value).to have_text 'Bowled Out!'
    end
  end

end
