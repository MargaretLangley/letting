require 'spec_helper'

describe Client do

  before(:each) do
    log_in
    client_create! human_ref: 111,
                   address_attributes: { road: 'Vauxall Lane' }
    client_create! human_ref: 222
    client_create! human_ref: 333
    visit '/clients/'
  end

  context '#index' do

    it 'basic' do
      expect(current_path).to eq '/clients/'

      # shows multiple rows
      expect(page).to have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'

      # displays multiple columns/
      expect(page).to have_text 'W G'
      expect(page).to have_text 'Grace'
      expect(page).to have_text 'Edgbaston Road'
    end

    it 'search road' do
      pending 'search'
      fill_in 'search', with: 'Edgbaston Road'
      click_on 'Search'
      expect(page).to_not have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'
    end

    it 'search number' do
      pending 'Search by number not working'
      fill_in 'search', with: '111'
      click_on 'Search'
      expect(page).to_not have_text '333'
      expect(page).to_not have_text '222'
      expect(page).to have_text '111'
    end

    it 'search not found' do
      pending 'search'
      fill_in 'search', with: 'Highcroft Road'
      click_on 'Search'
      expect(page).to_not have_text '111'
      expect(page).to have_text 'No Clients Found'
    end

    it 'view' do
      first(:link, 'View').click
      expect(page).to have_text '111'
      expect(page).to have_text 'Edit'
      expect(page).to have_text 'Properties Owned'
    end

  end
end
