# rubocop:disable LineLength
require 'rails_helper'

describe 'PrintShow', type: :feature do
  describe '#show' do
    it 'basic' do
      setup products: [product_new(charge_type: ChargeTypes::GROUND_RENT)]
      visit '/single_prints/1'
      expect(page.title).to eq 'Letting - Invoicing Single Print'
      expect(page).to have_text 'Harry'
      expect(page).to have_text '1984'
      expect(page).to have_text '30/06/2014'
    end

    describe 'back page is used for Ground Rents & Garage Ground Rents only' do
      it 'displays back page for ground rents and garage ground rent only' do
        setup products: [product_new(charge_type: ChargeTypes::GARAGE_GROUND_RENT)]
        visit '/single_prints/1'

        expect(page).to have_text 'Garage Ground Rent'
        expect(page).to have_text 'Act 2002'
      end

      it 'is left blank without ground rent' do
        setup products: [product_new(charge_type: ChargeTypes::INSURANCE)]
        visit '/single_prints/1'

        expect(page).to have_text '1984'
        expect(page).to have_text 'Insurance'
        expect(page).to_not have_text 'Act 2002'
      end
    end

    def setup(products:)
      log_in admin_attributes
      invoice_text_create id: 1,
                          invoice_name: 'Harry',
                          address: address_new(road: 'High')
      invoice_text_create id: 2, heading1: 'Act 2002'
      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }

      property = property_create(human_ref: 1984,
                                 occupiers: [Entity.new(name: 'Smiths')])

      run_create id: 1, invoices: [invoice_create(id: 1, property: property, products: products)]
    end
  end
end
