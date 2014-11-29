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
        run = run_new
        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: ['a comment']
        expect(run.invoices.first.comments.size).to eq 1
        expect(run.invoices.first.comments.first.clarify).to eq 'a comment'
      end
    end
    context 'second run' do
      it 'sets comments' do
        run = run_new
        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: []
        run.prepare invoice_date: Date.new(2001, 1, 1),
                    comments: ['a comment']
        expect(run.invoices.last.comments.size).to eq 1
        expect(run.invoices.last.comments.first.clarify).to eq 'a comment'
      end
    end
  end
end
