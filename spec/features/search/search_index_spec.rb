require 'rails_helper'

describe 'Search index', type: :feature do
  before(:each) { log_in }

  describe 'index', :search do
    it 'visits literal matches' do
      property_create human_ref: 111,
                      account: account_new(charge: charge_new)
      property_create human_ref: 222,
                      account: account_new(charge: charge_new)
      visit '/properties'
      fill_in 'search_terms', with: '222'
      click_on 'search'
      expect(page.title).to eq 'Letting - View Account'
      expect(page).to have_text '222'
    end

    it 'indexes full-text search' do
      property_create human_ref: 111,
                      account: account_new,
                      address_attributes: { county: 'Worcester' }
      property_create human_ref: 222,
                      account: account_new,
                      address_attributes: { county: 'West Midlands' }
      property_create human_ref: 333,
                      account: account_new,
                      address_attributes: { county: 'West Midlands' }
      Property.import force: true, refresh: true
      visit '/properties'
      fill_in 'search_terms', with: 'Wes'
      click_on 'search'
      expect(page).to_not have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'
      Property.__elasticsearch__.delete_index!
    end

    it 'handles multiple requests' do
      property_create human_ref: 111,
                      account: account_new,
                      address_attributes: { county: 'Worcester' }
      Property.import force: true, refresh: true
      visit '/properties'
      fill_in 'search_terms', with: 'Wor'
      click_on 'search'
      expect(page).to have_text '111'
      click_on 'search'
      expect(page).to have_text '111'
      Property.__elasticsearch__.delete_index!
    end

    it 'empty search returns a default result set' do
      property_create human_ref: 111, account: account_new
      Property.import force: true, refresh: true
      visit '/properties'
      fill_in 'search_terms', with: ''
      click_on 'search'
      expect(page).to have_text '111'
      Property.__elasticsearch__.delete_index!
    end

    it 'search not found when absent' do
      property_create human_ref: 111, account: account_new
      Property.import force: true, refresh: true
      visit '/properties'
      fill_in 'search_terms', with: '599'
      click_on 'search'
      expect(page).to have_text 'No Matches found. Search again.'
      Property.__elasticsearch__.delete_index!
    end
  end
end
