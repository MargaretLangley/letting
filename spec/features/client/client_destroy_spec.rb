require 'spec_helper'

describe Client do

  it '#destroys' do
    client_factory human_client_id: 9000
    visit '/clients'
    expect(page).to have_text '9000'
    expect{ click_on 'Delete'}.to change(Client, :count).by -1
    expect(page).not_to have_text '9000'
    expect(page).to have_text 'Client successfully deleted!'
    expect(current_path).to eq '/clients'
  end
end