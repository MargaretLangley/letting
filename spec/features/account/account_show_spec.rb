require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

  before(:each) do
    log_in
    property_with_billing_create! id: 1, human_ref: 1000
    visit '/accounts/'
    click_on 'View Accounts'
  end

  context '#show' do

    it 'basic' do
      expect(current_path).to eq '/accounts/1'
      expect_property_address
      expect_property_entity
      expect_billing_info
    end

    it 'navigates to index page' do
      click_on 'Properties'
      expect(page).to have_text 'Town'
      expect(page).to have_text 'Road'
      expect(page).to have_text '1'
    end

    def expect_property_address
      expect(page).to have_text '1000'
      expect_address_edgbaston
    end

    def expect_property_entity
      expect_entity_wg_grace
    end

    def expect_billing_info
      expect_billing_address
      expect_billing_entity
    end

    def expect_billing_entity
      expect(page).to have_text 'Rev'
      expect(page).to have_text 'V W'
      expect(page).to have_text 'Knutt'
    end

    def expect_billing_address
      expect(page).to have_text '33'
      expect(page).to have_text 'The Oval'
      expect(page).to have_text '207b'
      expect(page).to have_text 'Vauxhall Street'
      expect(page).to have_text 'Kennington'
      expect(page).to have_text 'London'
      expect(page).to have_text 'Greater London'
      expect(page).to have_text 'SE11 5SS'
    end
  end

end
