require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe InvoicingMaker, type: :model do
  describe '#generate' do
    it 'invoice when an account is within property and date range' do
      template_create id: 1
      charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account_create property: property_new(human_ref: 8, client: client_new),
                     charge: charge

      invoicing =
        InvoicingMaker.new property_range: '8-8',
                           period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)
      invoicing.generate
      expect(invoicing.invoices.size).to eq 1
    end

    describe 'product arrears' do
      it 'no outstanding debts, no arrears' do
        template_create id: 1
        account_create property: property_new(human_ref: 8, client: client_new),
                       charge: charge_new

        invoicing =
          InvoicingMaker.new property_range: '8-8',
                             period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)
        invoicing.generate
        expect(invoicing.invoices.first.products.size).to eq 1
        expect(invoicing.invoices.first.products.first.charge_type)
          .to_not eq 'Arrears'
      end

      it 'outstanding debts, make arrears' do
        template_create id: 1
        account_create property: property_new(human_ref: 8, client: client_new),
                       charge: charge_find_or_create(id: 1),
                       debits: [debit_new(amount: 50.00,
                                          on_date: Date.new(2009, 3, 1),
                                          charge: charge_find_or_create(id: 1))]

        invoicing =
          InvoicingMaker.new property_range: '8-8',
                             period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)
        invoicing.generate
        expect(invoicing.invoices[0].products.first.charge_type).to eq 'Arrears'
        expect(invoicing.invoices[0].products.first.amount).to eq 50.00
      end
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        template_create id: 1
        charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
        account_create property: property_new(human_ref: 6000), charge: charge

        invoicing =
          InvoicingMaker.new(property_range: '8-8',
                             period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1))
        invoicing.generate
        expect(invoicing.invoices.size).to eq 0
      end

      it 'charges outside start_date and end_date' do
        template_create id: 1
        charge = charge_new cycle: cycle_new(due_ons: [due_on_new(month: 6)])
        account_create property: property_new(human_ref: 8), charge: charge

        invoicing =
          InvoicingMaker.new property_range: '8-8',
                             period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)
        invoicing.generate
        expect(invoicing.invoices.size).to eq 0
      end
    end
  end

  describe '#generateable?' do
    it 'returns true when invoicing possible' do
      template_create id: 1
      charge = charge_new cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account_create property: property_new(human_ref: 8), charge: charge

      invoicing =
        InvoicingMaker.new property_range: '8-8',
                           period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)

      expect(invoicing.generateable?).to eq true
    end

    it 'returns false when invoicing not possible' do
      template_create id: 1
      account_create property: property_new(human_ref: 6000), charge: charge_new

      invoicing =
        InvoicingMaker.new property_range: '8-8',
                           period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1)

      expect(invoicing.generateable?).to eq false
    end
  end
end
