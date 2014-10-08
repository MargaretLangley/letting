require 'rails_helper'

describe Template, type: :feature do

  before(:each) do
    log_in admin_attributes
    template_create id: 1,
                    address: address_new(road: 'High')
  end

  context '#view' do
    it 'finds view page 1' do
      visit '/templates/1'
      expect(page.title). to eq 'Letting - View Invoice Text'
    end

    it 'finds address' do
      visit '/templates/1'
      expect(page).to have_text 'High'
    end

    it 'has edit link' do
      visit '/templates/1'
      expect(page.title). to eq 'Letting - View Invoice Text'
      click_on('Edit')
      expect(page.title). to eq 'Letting - Edit Invoice Text'
    end
  end
end
