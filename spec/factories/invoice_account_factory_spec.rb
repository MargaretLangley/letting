require 'rails_helper'

describe 'InvoiceAccount Factory' do
  describe 'default' do
    it('is valid') { expect(invoice_new).to be_valid }

    context 'makes' do
      it 'makes debits' do
        expect { invoice_account_new.save! }.to change(Debit, :count).by(1)
      end
    end
  end
end
