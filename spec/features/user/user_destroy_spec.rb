require 'rails_helper'

describe User, type: :feature do

  before(:each) { log_in admin_attributes }
  context '#destroys' do
    it 'basic' do
      skip 'deleting admin user (which log_in as) giving errory - review test'
      user_create! george_attributes
      visit '/users/'
      expect(current_path).to eq '/users/'
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_link 'View'
      expect(page).to have_link 'Edit'
      expect { first(:link, 'Delete').click }.to change(User, :count).by(-1)
      expect(current_path).to eq '/users'
    end
  end
end
