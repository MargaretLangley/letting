require 'spec_helper'

describe Client, type: :feature do

  before(:each) do
    log_in
    client_create!
  end

  it '#destroys' do
    visit '/clients'
    expect(page).to have_text '8008'
    expect { click_on 'Delete' }.to change(Client, :count).by(-1)
    expect(page).to have_text '8008'
    expect(page).to have_text 'successfully deleted!'
    expect(current_path).to eq '/clients'
  end
end
