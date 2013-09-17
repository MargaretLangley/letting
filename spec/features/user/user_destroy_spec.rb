require 'spec_helper'

describe User do

  before(:each) { log_in }
  context '#destroys' do
    it 'basic' do
      user_factory admin_attributes
      user_factory george_attributes
      user_factory bob_attributes
      visit '/users/'
      expect(current_path).to eq '/users/'
      expect(page).to have_text 'admin@example.com'
      expect(page).to have_text 'View'
      expect(page).to have_text 'Edit'
      expect{ first(:link,'Delete').click }.to change(User, :count).by -1
      expect(current_path).to eq '/users'
    end
  end
end