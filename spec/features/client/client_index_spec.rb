require 'spec_helper'

describe Client do

  before(:each) { log_in }

  context '#index' do

    it 'basic' do
      client_create! human_id: 101
      client_create! human_id: 102
      client_create! human_id: 103

      visit '/clients/'
      expect(current_path).to eq '/clients/'

      # shows multiple rows
      expect(page).to have_text '101'
      expect(page).to have_text '102'
      expect(page).to have_text '103'

      # displays multiple columns
      expect(page).to have_text 'W G'
      expect(page).to have_text 'Grace'
      expect(page).to have_text 'Edgbaston Road'
    end

    it 'search' do
      client_create! human_id: 111,
                     address_attributes: { road: 'Vauxall Lane' }
      client_create! human_id: 222
      client_create! human_id: 333

      visit '/clients'

      fill_in 'search', with: 'Edgbaston Road'
      click_on 'Search'
      expect(page).to_not have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'
    end

    it 'view' do
      client_create! human_id: 111,
                     address_attributes: { road: 'Vauxall Lane' }
      visit '/clients'
      click_on 'View'
      expect(page).to have_text '111'
      expect(page).to have_text 'Edit'
      expect(page).to have_text 'Properties Owned'
    end

  end
end
