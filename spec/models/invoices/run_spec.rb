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

  describe '#prepare' do
    context 'first run' do
      it 'sets comments' do
        account_create property: property_new(human_ref: 8)
        invoice_text_create id: TEXT_PAGE_1
        run = run_new invoices: [],
                      invoicing: invoicing_new(property_range: '1-10')
        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: ['a comment']

        expect(run.invoices.first.comments.size).to eq 1
        expect(run.invoices.first.comments.first.clarify).to eq 'a comment'
      end
    end
    context 'second run' do
      it 'sets comments' do
        account_create property: property_new(human_ref: 8)
        run = run_new invoicing: invoicing_new(property_range: '1-10')
        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: []

        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: ['a comment']
        expect(run.invoices.last.comments.size).to eq 1
        expect(run.invoices.last.comments.first.clarify).to eq 'a comment'
      end
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
