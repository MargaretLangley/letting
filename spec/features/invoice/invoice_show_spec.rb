require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do

    it 'basic' do
      setup
      visit '/invoices/1'
      expect(page.title).to eq 'Letting - Invoice View'
      expect(page).to have_text '30/06/2015'
    end

    describe 'back page is used for Ground Rents & Garage Ground Rents only' do

      it 'displays back page with ground rent, uses template 2' do
        setup products: [product_new(charge_type: 'Ground Rent')]
        visit '/invoices/1'
        # the second page information includes legal act (Act 2002)'
        expect(page).to have_text 'Act 2002'
      end

      it 'displays back page with garage ground rent, uses template 2' do
        setup products: [product_new(charge_type: 'Garage Ground Rent')]
        visit '/invoices/1'
        expect(page).to have_text 'Act 2002'
      end

      it 'is left blank without ground rent' do
        setup products: [product_new(charge_type: 'Service Charge')]
        visit '/invoices/1'
        expect(page).to_not have_text 'Act 2002'
      end
    end

    def setup(*)
      log_in admin_attributes
      template_create id: 1,
                      invoice_name: 'Harry',
                      address: address_new(road: 'High')
      template_create id: 2, heading1: 'Act 2002'

      property = property_new(human_ref: 2002,
                              occupiers: [Entity.new(name: 'Smiths')])

      invoice_create id: 1, invoice_date: '2015/06/30', property: property

      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }
    end
  end
end
