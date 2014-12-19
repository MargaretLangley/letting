require 'rails_helper'

RSpec.describe ReRunMaker, type: :model do
  describe 'invoices' do
    it 'recreates a run of invoices' do
      rerun = ReRunMaker.new invoices: [invoice_new]

      expect(rerun.run.size).to eq 1
    end

    it 'does not create run if no accounts in range' do
      rerun = ReRunMaker.new invoices: []

      expect(rerun.run.size).to eq 0
    end
  end

  describe 'invoice_date' do
    it 'defaults to today' do
      invoices = [invoice_new(invoice_date: '2000/01/01')]
      rerun = ReRunMaker.new invoices: invoices
      expect(rerun.run.first.invoice_date).to eq Time.zone.today
    end

    it 'can set date' do
      invoices = [invoice_new(invoice_date: '2000/01/01')]
      rerun = ReRunMaker.new invoices: invoices, invoice_date: '2010/02/02'
      expect(rerun.run.first.invoice_date).to eq Date.new(2010, 2, 2)
    end
  end

  describe 'comments' do
    it 'sets comments' do
      invoices = [invoice_new(invoice_date: '2000/01/01')]

      rerun = ReRunMaker.new invoices: invoices, comments: ['a comment']

      expect(rerun.run.first.comments.size).to eq 1
      expect(rerun.run.first.comments.first.clarify).to eq 'a comment'
    end

    it 'if comments unset it leaves them blank' do
      invoices = [invoice_new(invoice_date: '2000/01/01')]
      rerun = ReRunMaker.new invoices: invoices, comments: []

      expect(rerun.run.first.comments.size).to eq 0
    end
  end
end
