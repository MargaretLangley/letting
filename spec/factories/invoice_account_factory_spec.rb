require 'rails_helper'

describe 'Snapshot Factory' do
  describe 'default' do
    it('is valid') { expect(invoice_new).to be_valid }

    context 'makes' do
      it 'makes debits' do
        expect { snapshot_new.save! }.to change(Debit, :count).by(1)
      end
    end
  end
end
