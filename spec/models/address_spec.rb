require 'spec_helper'

describe Address do

  let(:address) { Address.new address_attributes addressable_id: 1}

  it ('valid') { expect(address).to be_valid }

  context 'associations' do
    it 'is associated with a addressable' do
      expect(address).to respond_to(:addressable)
    end
  end

  context 'validations' do

  end

  context 'methods' do

    context '#empty?' do

      let(:address) { Address.new }

      it ('new address is empty') { expect(address).to be_empty }

      it 'new address with attribute set is not empty' do
        address.town = 'London'
        expect(address).to_not be_empty
      end

      it 'new address with ignored attribute set is empty' do
        address.id = 8
        expect(address).to be_empty
      end

    end
  end
end
