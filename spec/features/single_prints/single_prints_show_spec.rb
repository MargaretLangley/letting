# rubocop:disable MethodLength
require 'rails_helper'

describe 'PrintShow', type: :feature do

  describe '#show' do

    before(:each) do
      setup
      visit '/single_prints/1'
    end

    it 'basic' do
      expect(page.title).to eq 'Letting - Invoicing Single Print'
      expect(page).to have_text '30/06/2015'
    end

    it 'finds first page invoice details' do
      expect(page).to have_text 'Property Ref: 2002'
    end

    it 'finds first template details' do
      expect(page).to have_text 'Harry'
      expect(page).to have_text 'Tel: 01710008'
    end

    it 'finds template  address details' do
      expect(page).to have_text 'High'
    end

    it 'finds 2nd page invoice details' do
      expect(page).to have_text 'Smiths'
    end

    it 'finds second template details' do
    end

    it 'finds 2nd page guide details' do
      expect(page).to have_text 'inst'
    end

    def setup
      log_in admin_attributes
      template_create id: 1,
                      invoice_name: 'Harry',
                      address: address_new(road: 'High')
      template_create id: 2, heading1: 'Act 2002'

      property = property_new(human_ref: 2002,
                              occupiers: [Entity.new(name: 'Smiths')])
      invoice_create id: 1,
                     invoice_date: '2015/06/30',
                     property: property

      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }
    end
  end
end
