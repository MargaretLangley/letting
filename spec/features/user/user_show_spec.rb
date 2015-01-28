require 'rails_helper'
describe User, type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  context '#show' do
    it 'basic user in show page' do
      user_create nickname: 'other', email: 'other@example.com'
      visit '/users/'
      expect(current_path).to eq '/users/'
      first('.view-testing-link', visible: false).click
      expect(page).to have_text 'other@example.com'
      expect(page).to have_text 'other'
    end
  end
end
