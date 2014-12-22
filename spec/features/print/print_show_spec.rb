# rubocop:disable MethodLength
require 'rails_helper'

describe 'PrintShow', type: :feature do
  describe '#show' do
    it 'basic' do
      setup
      visit '/prints/1'
      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '30/06/2014'
    end

    describe 'back page is used for Ground Rents & Garage Ground Rents only' do
      it 'displays back page with ground rent, uses invoice_text 2' do
        setup products: [product_new(charge_type: 'Ground Rent')]
        visit '/prints/1'
        # the second page information includes legal act (Act 2002)'
        expect(page).to have_text 'Act 2002'
      end

      it 'displays back page with garage ground rent, uses invoice_text 2' do
        setup products: [product_new(charge_type: 'Garage Ground Rent')]
        visit '/prints/1'
        expect(page).to have_text 'Act 2002'
      end

      it 'is left blank without ground rent' do
        setup products: [product_new(charge_type: 'Service Charge')]
        visit '/prints/1'
        expect(page).to_not have_text 'Act 2002'
      end
    end

    def setup invoice_name: 'Harry', products: [product_new]
      log_in admin_attributes
      invoice_text_create id: 1,
                          invoice_name: invoice_name,
                          address: address_new(road: 'High')
      invoice_text_create id: 2, heading1: 'Act 2002'

      property = property_new(human_ref: 2002,
                              occupiers: [Entity.new(name: 'Smiths')])
      invoice = invoice_create invoice_date: '2014/06/30',
                               property: property,
                               products: products
      invoicing_create id: 1,
                       property_range: '1-200',
                       period_first: '2014/06/30',
                       period_last: '2014/08/30',
                       runs: [run_new(id: 1, invoices: [invoice])]

      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }
    end
  end
end
