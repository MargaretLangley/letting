require 'rails_helper'

describe Template, type: :feature do

  before(:each) do
    log_in admin_attributes
  end

  context '#index' do

    it 'checks data' do
      template_create id: 2, description: 'Page 2'
      visit '/templates/'
      expect(page).to have_title 'Letting - Invoice Texts'
      expect(page).to have_text 'Page 2'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'View'
    end

    it 'has edit link' do
      template_create
      visit '/templates/'
      click_on 'Edit'
      expect(page.title).to eq 'Letting - Edit Invoice Text'
    end

    it 'has view link on icon' do
      template_create
      visit '/templates/'
      click_on 'View'
      expect(page.title).to eq 'Letting - View Invoice Text'
    end

    it 'has ordered list' do
      template_create id: 1, invoice_name: 'Morgan'
      visit '/templates/'
      first(:link, 'Edit').click
      expect(page).to have_text 'Page 1'
      expect(find_field('Invoice Name').value).to have_text 'Morgan'
    end
  end
end