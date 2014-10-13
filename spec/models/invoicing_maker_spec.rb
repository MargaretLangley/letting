require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe InvoicingMaker, type: :model do
  describe '#generate' do
    it 'invoice when an account is within property and date range' do
      template_create id: 1
      property = property_new human_ref: 20, client: client_new
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      charge = charge_new charge_cycle: cycle
      account_create property: property,
                     charge: charge,
                     debits: [debit_new(charge: charge)]

      invoicing = InvoicingMaker.new(property_range: '20-20',
                                     period: Date.new(2010, 3, 1)..
                                                     Date.new(2010, 5, 1))
      invoicing.generate
      expect(invoicing.invoices.size).to eq 1
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        template_create id: 1
        property = property_new human_ref: 10
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
        charge = charge_new charge_cycle: cycle
        account_create property: property,
                       charge: charge,
                       debits: [debit_new(charge: charge)]

        invoicing = InvoicingMaker.new(property_range: '20-20',
                                       period: Date.new(2010, 3, 1)..
                                                       Date.new(2010, 5, 1))
        invoicing.generate
        expect(invoicing.invoices.size).to eq 0
      end

      it 'charges outside start_date and end_date' do
        template_create id: 1
        property = property_new human_ref: 20
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
        charge = charge_new charge_cycle: cycle
        account_create property: property,
                       charge: charge,
                       debits: [debit_new(charge: charge)]

        invoicing = InvoicingMaker.new(property_range: '20-20',
                                       period: Date.new(2010, 3, 1)..
                                                       Date.new(2010, 5, 1))
        invoicing.generate
        expect(invoicing.invoices.size).to eq 0
      end
    end
  end

  describe '#generateable?' do
    it 'returns true when invoicing possible' do
      template_create id: 1
      property = property_new human_ref: 20
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      charge = charge_new charge_cycle: cycle
      account_create property: property,
                     charge: charge,
                     debits: [debit_new(charge: charge)]

      invoicing = InvoicingMaker.new(property_range: '20-20',
                                     period: Date.new(2010, 3, 1)..
                                                     Date.new(2010, 5, 1))

      expect(invoicing.generateable?).to eq true
    end

    it 'returns false when invoicing not possible' do
      template_create id: 1
      property = property_new human_ref: 10
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      charge = charge_new charge_cycle: cycle
      account_create property: property,
                     charge: charge,
                     debits: [debit_new(charge: charge)]

      invoicing = InvoicingMaker.new(property_range: '20-20',
                                     period: Date.new(2010, 3, 1)..
                                                     Date.new(2010, 5, 1))

      expect(invoicing.generateable?).to eq false
    end
  end
end
