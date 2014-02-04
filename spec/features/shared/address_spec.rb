require 'spec_helper'

describe Address do
  before(:each) { log_in }

  context '#updates' do
    let(:client_update) { ClientUpdatePage.new }
    let(:address) { AddressPage.new }

    it 'Add district line', js: true do
      client_create! address_attributes: { district: '' }
      navigate_to_edit_page
      expect(address).to_not be_district_visible
      address.add_district
      expect(address).to be_district_visible
    end

    it 'Display district if added', js: true do
      pending 'can not get this working in the test - documentations says( Not all drivers support CSS, so the result may be inaccurate.) '
      client_create! address_attributes: { district: 'Edgebaston' }
      navigate_to_edit_page
      expect(address).to be_district_visible
      address.delete_district
      expect(address).to_not be_district_visible
    end

    def navigate_to_edit_page
      visit '/clients/'
      click_on 'Edit'
    end
  end
end