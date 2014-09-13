require 'rails_helper'
require_relative '../shared/address'

describe Property, type: :feature do

  before(:each) { log_in }

  context '#index' do

    it 'basic' do
      property_create human_ref: 111, account: account_new
      property_create human_ref: 222, account: account_new
      property_create human_ref: 333, account: account_new

      visit '/properties/'
      # shows more than one row
      expect(page).to have_text '111'
      expect(page).to have_text '222'

      # Displays expected columns
      expect(page).to have_text '333'
      expect_index_address
    end
  end
end
