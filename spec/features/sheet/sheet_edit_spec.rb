require 'spec_helper'

describe Sheet do

  before(:each) { log_in }

  context '#edit' do
    it 'finds data ok' do
      sheet = sheet_factory
      visit "/sheets/#{sheet.id}/edit"
      expect(page).to have_title 'Edit Sheet'
      expect(find_field('Invoice Name').value).to have_text 'Estates Ltd'
    end
  end

  context '#edit' do
    it 'finds data page 2  & goes to view page' do
      sheet = sheet_factory
      sheet = sheet2_factory
      visit '/sheets/'
      click_on('2')
      expect(page).to have_title 'Edit Sheet'
      expect(find_field('1st Text Block').value).to have_text 'Bowled Out!'
      click_on('View')
      expect(page).to have_text 'Page2 head1'
    end
  end
end
