require 'rails_helper'

describe Client, type: :feature do
  let(:client_page) { ClientPage.new }
  before(:each) do
    log_in
    client_page.new
  end

  def new_person **overrides
    { title: 'Mr', initials: 'I R', name: 'Bell' }.merge overrides
  end

  def add_person **overrides
    { title: 'Mr', initials: 'A', name: 'Cook' }.merge overrides
  end

  context 'creating client' do
    it 'opens valid page', js: true  do
      expect(current_path).to eq '/clients/new'
      expect(page).to have_css('.spec-entity-count', count: 1)
    end

    it 'can be added', js: true do
      client_page.click 'Add district'
      client_page.fill_in_client_id(278)
      client_page.fill_in_entity(order: 0, **new_person)
      client_page.fill_in_address(address_attributes(town: 'York'))
      client_page.button('Create')
      expect(client_page).to be_successful
      client_page.edit
      client_page.expect_ref(self, 278)
      client_page.expect_entity(self, order: 0, **new_person(name: 'Bell'))
      client_page.expect_address(self, address_attributes(town: 'York'))
    end

    it 'can validate' do
      client_page.button('Create')
      expect(page).to have_text 'The client could not be saved.'
    end

    it 'can cancel' do
      client_page.fill_in_entity(order: 0, **new_person(name: 'Bell'))
      client_page.click('Cancel')
      expect(client_page.title).to eq 'Letting - Clients'
      expect(page).to_not have_text 'Bell'
    end

    it 'has add and remove actions', js: true do
      client_page.click('Add Person')
      expect(page).to have_css('.spec-entity-count', count: 2)
      client_page.fill_in_entity(order: 1, **add_person)
      client_page.click('Delete Person')
      expect(page).to have_css('.spec-entity-count', count: 1)
    end
  end
end
