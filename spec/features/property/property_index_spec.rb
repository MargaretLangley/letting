require 'rails_helper'

describe Property, type: :feature do

  before(:each) { log_in }

  describe '#index' do

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

    def expect_index_address
    [
      '47',             # Flat No
      'Hillbank House', # House Name
      '294',            # House No
      'Edgbaston Road', # Road
      'Birmingham'      # Town
    ].each do |line|
      expect(page).to have_text line
    end
  end
  end
end
