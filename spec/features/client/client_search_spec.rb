require 'spec_helper'
require_relative '../shared/address'

describe Client, type: :feature do

  before(:each) { log_in }

  describe '#Search' do

    before :each do
      client_create! human_ref: 2111,
                     address_attributes: { county: 'Worcester' }
      client_create! human_ref: 2222,
                     address_attributes: { county: 'West Midlands' }
      client_create! human_ref: 2333,
                     address_attributes: { county: 'West Midlands' }
      Client.import force: true, refresh: true
    end

    after :each do
      Client.__elasticsearch__.delete_index!
    end

    it 'found when present' do
      visit '/clients'
      fill_in 'search', with: 'Wes'
      click_on('search')
      expect(page).to_not have_text '2111'
      expect(page).to have_text '2222'
      expect(page).to have_text '2333'
    end

    it 'search not found when absent' do
      visit '/clients'
      fill_in 'search', with: '2599'
      click_on('search')
      expect(page).to have_text 'No Matches found. Search again.'
    end
  end
end
