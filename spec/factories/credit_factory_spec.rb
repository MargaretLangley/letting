require 'rails_helper'

describe 'Credit Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(credit_new).to be_valid }
      it('has amout') { expect(credit_new.amount).to eq(-88.08) }
      it('has date') { expect(credit_new.on_date.to_s).to eq '2013-04-30' }
    end
    describe 'overrides' do
      it 'alters amount' do
        expect(credit_new(amount: -35.50).amount).to eq(-35.50)
      end
      it 'alters date' do
        expect(credit_new(on_date: '10/6/2014').on_date.to_s).to eq '2014-06-10'
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is created' do
        expect { credit_create }.to change(Credit, :count).by(1)
      end
      it('has amout') { expect(credit_create.amount).to eq(-88.08) }
      it('has date') { expect(credit_create.on_date.to_s).to eq '2013-04-30' }
    end
    describe 'override' do
      it 'alters amount' do
        expect(credit_create(amount: -35.50).amount).to eq(-35.50)
      end
      it 'alters date' do
        expect(credit_create(on_date: '10/6/2014').on_date.to_s)
          .to eq '2014-06-10'
      end
    end
  end
end
