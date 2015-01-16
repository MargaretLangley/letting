require 'rails_helper'

describe 'Client navigate', type: :feature do
  before(:each) { log_in }

  describe 'from index page' do
    it 'to view client' do
      client_create human_ref: 111
      visit '/clients/'

      first('.view-testing-link', visible: false).click

      expect(page).to have_text '111'
      expect(page.title).to eq 'Letting - View Client'
    end

    it 'to edit client' do
      client_create id: 1, human_ref: 111
      visit '/clients/'

      first(:link, 'Edit').click

      expect(page.title).to eq 'Letting - Edit Client'
      expect(ClientPage.new.ref).to eq 111
    end
  end

  describe 'from show page' do
    it 'to index page' do
      client_create id: 1
      visit '/clients/1'
      click_on 'Clients'
      expect(page.title).to eq 'Letting - Clients'
    end

    it 'to edit page' do
      client_create id: 1
      visit '/clients/1'
      click_on 'Edit'
      expect(page.title).to eq 'Letting - Edit Client'
    end
  end

  describe 'from edit page' do
    it 'to view page' do
      client_create id: 1
      (client_page = ClientPage.new).load id: 1
      expect(client_page.title).to eq 'Letting - Edit Client'

      click_on 'View file'

      expect(page.title).to eq 'Letting - View Client'
    end
  end
end
