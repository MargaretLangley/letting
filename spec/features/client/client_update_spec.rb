require 'rails_helper'

describe 'Client#update', type: :feature do
  before(:each) { log_in }
  let(:client_page) { ClientPage.new }

  def add_person **overrides
    { title: 'Mr', initials: 'A', name: 'Cook' }.merge overrides
  end

  def amend_person **overrides
    { title: 'Mrs', initials: 'J', name: 'Smit' }.merge overrides
  end

  context 'with one entity' do
    before(:each) do
      client_create human_ref: 301
      client_page.edit
    end

    it 'opens valid page', js: true  do
      expect(client_page.title).to eq 'Letting - Edit Client'
      expect(page).to have_css '.spec-entity-count', count: 1
    end

    # Note ** combines keywords (order + amend_person) - splatted into call
    it 'amends', js: true do
      client_page.click 'Add district'
      client_page.fill_in_client_id 278
      client_page.fill_in_entity order: 0, **amend_person(name: 'Smit')
      client_page.fill_in_address address_attributes town: 'York'
      client_page.button 'Update'
      expect(client_page).to be_successful
      client_page.edit
      client_page.expect_ref self, 278

      expect(client_page.entity(order: 0)).to eq 'Mrs J Smit'
      client_page.expect_address self, address_attributes(town: 'York')
    end

    it 'has validation' do
      client_page.fill_in_client_id(-1) # invalidate_page
      client_page.button 'Update'
      expect(page).to have_text /The client could not be saved./i
    end

    it 'adds a second entity', js: true do
      client_page.click 'Add Person'
      client_page.fill_in_entity order: 1, **add_person(name: 'Cook')
      client_page.button 'Update'
      expect(client_page).to be_successful
      client_page.edit

      expect(client_page.entity(order: 1)).to eq 'Mr A Cook'
    end

    it 'cancel stops amend' do
      client_page.fill_in_entity order: 0, **amend_person(name: 'Smit')
      client_page.click 'Cancel'

      expect(client_page.title).to eq 'Letting - Clients'
      expect(page).to_not have_text 'Smit'
    end
  end

  context 'with two entity' do
    it 'deletes second entity', js: true do
      client_create human_ref: 301, entities: [Entity.new(name: 'Bell'),
                                               Entity.new(name: 'Prior')]
      client_page.edit

      client_page.click 'Delete Person'
      client_page.button 'Update'
      client_page.edit
      client_page.click 'Add Person'

      expect(client_page.entity(order: 1)).to eq ''
    end

    it 'does not add a third entity', js: true do
      client_create human_ref: 301, entities: [Entity.new(name: 'Bell'),
                                               Entity.new(name: 'Prior')]
      client_page.edit
      client_page.click 'Add Person'

      expect(page).to have_css '.spec-entity-count', count: 2
    end
  end
end
