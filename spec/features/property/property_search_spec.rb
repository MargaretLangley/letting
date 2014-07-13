require 'spec_helper'
require_relative '../shared/address'

describe Property, :type => :feature do

  before(:each) { log_in }

  describe '#Search' do

    before :each do
      property_create! human_ref: 111,
                       address_attributes: { county: 'Worcester' }
      property_create! human_ref: 222,
                       address_attributes: { county: 'West Midlands' }
      property_create! human_ref: 333,
                       address_attributes: { county: 'West Midlands' }
      Property.import force: true, refresh: true
    end

    after :each do
      Property.__elasticsearch__.delete_index!
    end

    it 'found when present' do
      visit '/properties'
      fill_in 'search', with: 'Wes'
      click_on 'Search'
      expect(page).to_not have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'
    end

    it 'search not found when absent' do
      fill_in 'search', with: '599'
      click_on 'Search'
      expect(page).to have_text 'No Matches found. Search again.'
    end
  end
end
