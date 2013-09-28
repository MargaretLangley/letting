require 'spec_helper'

describe Client do

  before(:each) do
    log_in
    client_create! human_id: 9000
  end

  it '#destroys' do
    visit '/clients'
    expect(page).to have_text '9000'
    expect{ click_on 'Delete'}.to change(Client, :count).by -1
    expect(page).to have_text '9000 client successfully deleted!'
    expect(current_path).to eq '/clients'
  end
end