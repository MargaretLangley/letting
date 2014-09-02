require 'rails_helper'

describe User, type: :feature do

  before(:each) { log_in admin_attributes }
  describe '#destroys' do
    it 'basic' do
      user_create nickname: 'adam'
      visit '/users/'
      expect(page.title).to eq 'Letting - Users'
      expect(page).to have_text 'admin@example.com'
      expect { first(:link, 'Delete').click }.to change(User, :count).by(-1)
      expect(page.title).to eq 'Letting - Users'
    end
  end
end
