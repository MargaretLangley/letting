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
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      expect(invoicing.actionable?).to be true
    end

    it 'can not be actionable' do
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 5, day: 2)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      expect(invoicing.actionable?).to be false
    end
  end

  describe '#generate?' do
    it 'can be true' do
      expect(invoicing_new).to be_generate
    end
    it 'can be false if range false' do
      expect(invoicing_new property_range: nil).to_not be_generate
    end
    it 'can be false if period false' do
      expect(invoicing_new period_first: nil, period_last: nil)
        .to_not be_generate
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
      invoicing.generate comments: ['', '']
      expect(invoicing.runs.size).to eq 1
      expect(invoicing.runs.first.invoices.size).to eq 1
    end

    it 'creates more than one run' do
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      invoicing.generate comments: ['', '']
      expect(invoicing.runs.size).to eq 2
    end

    it 'uses comments given to it to make invoices' do
      template_create id: 1
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 20, client: client_new),
                     charges: [charge_new(cycle: cycle)]

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      invoicing.generate comments: ['a comment']
      expect(invoicing.runs.last.invoices.first.comments.first.clarify)
        .to eq 'a comment'
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
        invoicing.generate comments: ['', '']
        expect(invoicing.runs.first.invoices).to eq []
      end
    end
  end
end
