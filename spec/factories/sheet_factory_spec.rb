require 'rails_helper'

describe 'Sheet Factory' do
  describe 'new' do
    # We create the object and test it has expected value
    describe 'default' do
      it 'has description' do
        expect(sheet_new.description).to eq 'Page 1 Invoice'
      end
      describe 'makes' do
        it 'has address' do
          expect(sheet_new.address).to_not be_nil
        end
      end
    end
    describe 'adds' do
      # adds notice..
    end
    describe 'overrides' do
      it 'changes description' do
        expect(sheet_new(description: 'new').description).to eq 'new'
      end

      it 'changes address' do
        expect(sheet_new(address: address_new(road: 'new')).address.road)
          .to eq 'new'
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is valid' do
        expect { sheet_create }.to change(Sheet, :count).by(1)
      end
      describe 'makes' do
        it 'builds address' do
          expect(sheet_create.address).to_not be_nil
        end
      end
    end
  end
end
