require 'spec_helper'

describe User, type: :feature do

  before(:each) { log_in admin_attributes }
  context '#index' do
    it 'basic users in view page' do
      user_create! george_attributes
      visit '/users/'
      expect(current_path).to eq '/users/'
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_text 'george@ulyett.com'
      expect(page).to have_link 'View'
      expect(page).to have_link 'Edit'
    end
  end
end
