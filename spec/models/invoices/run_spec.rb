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
    it 'sends invoice that has mail attribute true' do
      expect(run_new(invoices: [invoice_new(mail: true)]).deliver.size)
        .to eq 1
    end

    it 'keeps invoice that has mail attribute false' do
      expect(run_new(invoices: [invoice_new(mail: false)]).deliver.size)
        .to eq 0
    end
  end

  describe '#retain' do
    it 'keeps invoice that has mail attribute false' do
      expect(run_new(invoices: [invoice_new(mail: false)]).retain.size)
        .to eq 1
    end

    it 'sends invoice that has mail attribute' do
      expect(run_new(invoices: [invoice_new(mail: true)]).retain.size)
        .to eq 0
    end
  end

end
