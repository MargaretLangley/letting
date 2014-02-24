require 'spec_helper'

describe Sheet do
  before(:each) { log_in admin_attributes }
  context '#index' do
    it 'sheet index page exists' do
      visit '/sheets/'
      expect(current_path).to eq '/sheets/'
      expect(page).to have_text 'Heading'
      expect(page).to have_text 'Invoice Page'
      expect(page).to have_text 'Notice of Ground Rent '
      expect(page).to have_text 'Edit'
      expect(page).to have_text 'View'
    end

  end
end
