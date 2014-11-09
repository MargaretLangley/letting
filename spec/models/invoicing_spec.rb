require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe Invoicing, type: :model do
  it('is valid') { expect(invoicing_new).to be_valid }
  describe 'validates presence' do
    it 'property_range' do
      expect(invoicing_new property_range: nil).to_not be_valid
    end
    it 'period_first' do
      expect(invoicing_new period_first: nil).to_not be_valid
    end
    it 'period_last' do
      expect(invoicing_new period_last: nil).to_not be_valid
    end
    it('invoices') { expect(invoicing_new invoices: nil).to_not be_valid }
  end

  describe '#actionable?' do
    it 'can be actionable' do
      invoicing = Invoicing.new
      invoicing.invoices.build
      expect(invoicing.actionable?).to be true
    end

    it 'can be actionable' do
      invoicing = Invoicing.new
      expect(invoicing.actionable?).to be false
    end
  end

  describe '#generate' do
    it 'invoice when an account is within property and date range' do
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate
      expect(invoicing.invoices.size).to eq 1
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        template_create id: 1
        cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
        account_create property: property_new(human_ref: 6, client: client_new),
                       charges: [charge_new(cycle: cycle)]

        invoicing = Invoicing.new property_range: '20',
                                  period: Date.new(2010, 3, 1)..
                                          Date.new(2010, 5, 1)
        invoicing.generate
        expect(invoicing.invoices.size).to eq 0
      end
    end
  end
end
