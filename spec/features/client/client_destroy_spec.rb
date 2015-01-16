require 'rails_helper'

describe 'Client#destroys', type: :feature do
  before(:each) { log_in }

  it 'completes basic' do
    client_create

    visit '/clients'
    expect(page).to have_text '354'
    expect { click_on 'Delete' }.to change(Client, :count).by(-1)
    expect(page).to have_text '354'
    expect(page).to have_text 'deleted!'
    expect(current_path).to eq '/clients'
  end
end
