require 'spec_helper'
describe User do

  before(:each) { log_in admin_attributes }

  context '#view' do
    it 'basic user in view page' do
      user_create! george_attributes
      visit '/users/'
      expect(current_path).to eq '/users/'
      first(:link, 'View').click
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_text 'Print'
      expect(page).to have_text 'Admin'
    end
  end
end
