require 'spec_helper'

describe Address do

  let(:address) { Address.new address_attributes addressable_id: 1}

  it 'valid' do
    expect(address).to be_valid
  end

  context 'associations' do
    it 'is associated with a addressable' do
      expect(address).to respond_to(:addressable)
    end
  end

  context 'validations' do

  end

  context 'methods' do

    context '#empty?' do

      it 'new address is empty' do
        address = Address.new
        expect(address).to be_empty
      end

      it 'new address with attribute set is not empty' do
        address = Address.new
        address.town = 'London'
        expect(address).to_not be_empty
      end

      it 'new address with ignored attribute set is empty' do
        address = Address.new
        address.id = 8
        expect(address).to be_empty
      end

    end
  end

end
