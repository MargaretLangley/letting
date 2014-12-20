# rubocop:disable MethodLength
require 'rails_helper'

describe 'PrintShow', type: :feature do

  describe '#show' do

    it 'basic' do
      setup
      visit '/single_prints/1'
      expect(page.title).to eq 'Letting - Invoicing Single Print'
      expect(page).to have_text '30/06/2015'
    end

    describe 'display of back page' do

      it 'displays back page for ground rents and garage ground rent only' do
        setup products: [product_new(charge_type: 'Ground Rent')]
        visit '/single_prints/1'
        # the second page information includes legal act (Act 2002)'
        expect(page).to have_text 'Act 2002'
      end

      it 'is left blank without ground rent' do
        setup products: [product_new(charge_type: 'Service Charge')]
        visit '/single_prints/1'
        expect(page).to_not have_text 'Act 2002'
      end

    end

    def setup(*)
      log_in admin_attributes
      invoice_text_create id: 1,
                          invoice_name: 'Harry',
                          address: address_new(road: 'High')
      invoice_text_create id: 2, heading1: 'Act 2002'

      property = property_new(human_ref: 1984,
                              occupiers: [Entity.new(name: 'Smiths')])
      invoice_create id: 1,
                     invoice_date: '2015/06/30',
                     property: property

      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }
    end
  end
end
