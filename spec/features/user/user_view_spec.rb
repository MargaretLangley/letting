require 'spec_helper'
describe User, type: :feature do

  before(:each) { log_in admin_attributes }

  context '#view' do
    it 'basic user in view page' do
      visit '/users/'
      expect(current_path).to eq '/users/'
      find('.view-testing-link', visible: false).click
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_text 'Admin'
    end
  end
end
