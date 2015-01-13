require 'rails_helper'

RSpec.describe Run, type: :model do
  it('is valid') { expect(run_new).to be_valid }
  describe 'validates presence' do
    it '#invoice_date' do
      (run = run_new).invoice_date = nil
      expect(run).to_not be_valid
    end
    it '#invoices' do
      expect(run_new invoices: nil).to_not be_valid
    end
  end

  describe '#deliver' do
    it 'sends invoice that has deliver attribute true' do
      expect(run_new(invoices: [invoice_new(deliver: 'mail')]).deliver.size)
        .to eq 1
    end

    it 'keeps invoice that has deliver attribute false' do
      expect(run_new(invoices: [invoice_new(deliver: 'retain')]).deliver.size)
        .to eq 0
    end
  end

  describe '#retain' do
    it 'keeps invoice that has deliver attribute false' do
      expect(run_new(invoices: [invoice_new(deliver: 'retain')]).retain.size)
        .to eq 1
    end

    it 'sends invoice that has deliver attribute' do
      expect(run_new(invoices: [invoice_new(deliver: 'mail')]).retain.size)
        .to eq 0
    end
  end

  describe '#last?' do
    it 'can be last' do
      last = Run.new(invoices: [invoice_new])
      Invoicing.new.runs = [last]

      expect(last).to be_last
    end

    it 'can not be last' do
      first = Run.new(invoices: [invoice_new])
      last = Run.new(invoices: [invoice_new])
      Invoicing.new.runs = [first, last]

      expect(first).to_not be_last
    end
  end
end
