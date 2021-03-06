require 'rails_helper'

describe 'User#destroy', type: :feature do
  before(:each) { log_in admin_attributes }

  it 'destroys' do
    user_create nickname: 'adam'
    visit '/users/'
    expect(page.title).to eq 'Letting - Users'
    expect(page).to have_text 'system@example.com'
    expect { first(:link, 'Delete').click }.to change(User, :count).by(-1)
    expect(page.title).to eq 'Letting - Users'
  end
end
