require 'spec_helper'

describe Client, type: :feature do

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

    it 'view' do
      first('.view-testing-link', visible: false).click
      expect(page).to have_text '111'
      expect(page).to have_link 'Edit'
      expect(page).to have_text 'Properties Owned'
    end
  end
end
