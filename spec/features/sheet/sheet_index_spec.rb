require 'spec_helper'

describe Sheet, :type => :feature do

  before(:each) do
   log_in
  end

  context '#index' do

    it 'No pages' do
      visit '/sheets/'
      expect(current_path).to eq '/sheets/'
      expect(page).to have_title 'Sheets'
      expect(page).to have_text 'No Pages Found'
    end

    it 'Check Data' do
      sheet = sheet_factory
      visit '/sheets/'
      expect(page).to have_text '1'
      expect(page).to have_text 'Page 1'
      expect(page).to have_text 'Edit'
    end

  end
end
