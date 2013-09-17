require 'spec_helper'

describe User do

  before(:each) { log_in }
  context '#index' do
    it 'basic users in view page' do
      user_factory admin_attributes
      user_factory george_attributes
      user_factory bob_attributes
      visit '/users/'
      expect(current_path).to eq '/users/'
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_text 'george@ulyett.com'
      expect(page).to have_text 'bob@appleyard.com'
      expect(page).to have_text 'View'
      expect(page).to have_text 'Edit'
    end
  end
end