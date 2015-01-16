require 'rails_helper'

describe 'Client#index', type: :feature do
  before(:each) { log_in }

  it 'basic' do
    client_create  \
      human_ref: 111,
      entities: [Entity.new(title: 'Mr', initials: 'W G', name: 'Grace')],
      address: address_new(road: 'High St')
    client_create human_ref: 222
    client_create human_ref: 333

    visit '/clients/'

    expect(page.title).to eq 'Letting - Clients'

    expect(page).to have_text '111'
    expect(page).to have_text 'W. G. Grace'
    expect(page).to have_text 'High St'
    expect(page).to have_text '222'
    expect(page).to have_text '333'
  end
end
