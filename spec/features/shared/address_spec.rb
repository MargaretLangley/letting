require 'spec_helper'

describe Address, type: :feature do
  before(:each) { log_in }

  context '#updates' do
    let(:client_update) { ClientUpdatePage.new }
    let(:address) { AddressPage.new }

    it 'Add district line', js: true do
      client_create address_attributes: { district: '' }
      navigate_to_edit_page
      expect(address).to_not be_district_visible
      address.add_district
      expect(address).to be_district_visible
    end

    it 'Display district if added', js: true do
      skip 'can not get this working in the test - documentations
      says( Not all drivers support CSS, so the result may be inaccurate.) '
      client_create address_attributes: { district: 'Edgbaston' }
      navigate_to_edit_page
      expect(address).to be_district_visible
      address.delete_district
      expect(address).to_not be_district_visible
    end

    it 'Add nation line', js: true do
      client_create address_attributes: { nation: '' }
      navigate_to_edit_page
      expect(address).to_not be_nation_visible
      address.add_nation
      expect(address).to be_nation_visible
    end

    it 'Display nation if added', js: true do
      skip 'can not get this working in the test - documentations
      says( Not all drivers support CSS, so the result may be inaccurate.) '
      client_create address_attributes: { nation: 'Spain' }
      navigate_to_edit_page
      expect(address).to be_nation_visible
      address.delete_nation
      expect(address).to_not be_nation_visible
    end

    def navigate_to_edit_page
      visit '/clients/'
      click_on 'Edit'
    end
  end
end
