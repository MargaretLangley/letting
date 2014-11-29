require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe InvoicesMaker, type: :model do
  describe '#compose' do
    it 'invoice accounts within property and due date range' do
      template_create id: 1
      charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account_create property: property_new(human_ref: 8, client: client_new),
                     charges: [charge]

      invoicing =
        InvoicesMaker.new property_range: '8-8',
                          period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                          comments: []
      invoicing.compose
      expect(invoicing.invoices.size).to eq 1
    end

    describe 'product arrears' do
      it 'makes arrears from debts' do
        template_create id: 1
        account_create property: property_new(human_ref: 8, client: client_new),
                       charges: [charge_find_or_create(id: 1)],
                       debits: [debit_new(on_date: Date.new(2009, 3, 1),
                                          charge: charge_find_or_create(id: 1))]

        invoicing =
          InvoicesMaker.new property_range: '8-8',
                            period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                            comments: []
        invoicing.compose
        expect(invoicing.invoices[0].products.first.charge_type).to eq 'Arrears'
      end

      it 'No arrears unless outstanding debt' do
        template_create id: 1
        cycle = cycle_create due_ons: [DueOn.new(month: 3, day: 5)]
        account_create property: property_new(human_ref: 8, client: client_new),
                       charges: [charge_create(cycle: cycle)]
        invoicing =
          InvoicesMaker.new property_range: '8-8',
                            period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                            comments: []
        invoicing.compose
        expect(invoicing.invoices.first.products.size).to eq 1
        expect(invoicing.invoices.first.products.first.charge_type)
          .to_not eq 'Arrears'
      end
    end

    describe 'balancing' do
      it 'outstanding debts, make arrears' do
        template_create id: 1
        account_create property: property_new(human_ref: 8, client: client_new),
                       charges: [charge_find_or_create(id: 1, amount: 10)],
                       debits: [debit_new(amount: 30.00,
                                          on_date: Date.new(2009, 3, 1),
                                          charge: charge_find_or_create(id: 1))]

        invoicing =
          InvoicesMaker.new property_range: '8-8',
                            period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                            comments: []
        invoicing.compose
        expect(invoicing.invoices[0].products[0].balance).to eq 30.00
        expect(invoicing.invoices[0].products[1].balance).to eq 40.00
      end
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        template_create id: 1
        charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
        account_create property: property_new(human_ref: 600), charges: [charge]

        invoicing =
          InvoicesMaker.new property_range: '8-8',
                            period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                            comments: []
        invoicing.compose
        expect(invoicing.invoices.size).to eq 0
      end

      it 'charges outside start_date and end_date' do
        template_create id: 1
        charge = charge_new cycle: cycle_new(due_ons: [due_on_new(month: 6)])
        account_create property: property_new(human_ref: 8), charges: [charge]

        invoicing =
          InvoicesMaker.new property_range: '8-8',
                            period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                            comments: []
        invoicing.compose
        expect(invoicing.invoices.size).to eq 0
      end
    end
  end

  describe '#composeable?' do
    it 'returns true when invoicing possible' do
      template_create id: 1
      charge = charge_new cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account_create property: property_new(human_ref: 8), charges: [charge]

      invoicing =
        InvoicesMaker.new property_range: '8-8',
                          period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                          comments: []

      expect(invoicing.composeable?).to eq true
    end

    it 'returns false when invoicing not possible' do
      template_create id: 1
      account_create property: property_new(human_ref: 6), charges: [charge_new]

      invoicing =
        InvoicesMaker.new property_range: '8-8',
                          period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                          comments: []

      expect(invoicing.composeable?).to eq false
    end
  end
end
