require 'rails_helper'

describe 'Debit Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(debit_new).to be_valid }
      it('has amout') { expect(debit_new.amount).to eq(88.08) }
      it('has date') { expect(debit_new.on_date.to_s).to eq '2013-03-25' }
    end
    describe 'overrides' do
      it 'alters amount' do
        expect(debit_new(amount: 35.50).amount).to eq(35.50)
      end
      it('nils date') { expect(debit_new on_date: nil).to_not be_valid }
      it 'alters date' do
        expect(debit_new(on_date: '10/6/2014').on_date.to_s).to eq '2014-06-10'
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is created' do
        expect { debit_create }.to change(Debit, :count).by(1)
      end
      it('has amout') { expect(debit_create.amount).to eq(88.08) }
      it('has date') { expect(debit_create.on_date.to_s).to eq '2013-03-25' }
    end
    describe 'override' do
      it 'alters amount' do
        expect(debit_create(amount: 35.50).amount).to eq(35.50)
      end
      it 'alters date' do
        expect(debit_create(on_date: '10/6/2014').on_date.to_s)
          .to eq '2014-06-10'
      end
    end
  end
end
