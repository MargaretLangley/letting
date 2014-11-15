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
    it('runs') { expect(invoicing_new runs: nil).to_not be_valid }
  end

  describe '#actionable?' do
    it 'can be actionable' do
      (invoicing = Invoicing.new).runs.build.invoices.build
      expect(invoicing.actionable?).to be true
    end

    it 'can be actionable' do
      (invoicing = Invoicing.new).runs.build.invoices
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
      expect(invoicing.actionable?).to be true
    end

    it 'creates more than one run' do
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate
      invoicing.generate
      expect(invoicing.runs.size).to eq 2
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
        expect(invoicing.actionable?).to be false
      end
    end
  end
end
