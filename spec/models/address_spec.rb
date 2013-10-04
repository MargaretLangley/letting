require 'spec_helper'

describe Address do

  let(:address) { Address.new min_address_attributes }
  it('valid')   { expect(address).to be_valid }

  context 'validations' do

    context 'flat_no' do
      it 'can be blank' do
        address.flat_no = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.flat_no = 'a' * 11
        expect(address).to_not be_valid
      end
    end

    context 'house_name' do
      it 'can be blank' do
        address.house_name = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.house_name = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    context 'road no' do
      it 'can be blank '  do
        address.road_no = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.road_no = 'a' * 11
        expect(address).to_not be_valid
      end
    end

    context 'road' do
      it 'has to be present' do
        address.road = ''
        expect(address).to_not be_valid
      end

      it 'road has a max' do
        address.road = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    context 'district' do
      it 'can be blank' do
        address.district = ''
        expect(address).to be_valid
      end

      it 'has min' do
        address.district = 'aa'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.district = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    context 'town' do
      it 'can be blank' do
        address.town = ''
        expect(address).to be_valid
      end

      it 'has min' do
        address.town = 'aa'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.town = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    context 'county' do
      it 'must be present' do
        address.county = nil
        expect(address).not_to be_valid
      end

      it 'has min' do
        address.county = 'aa'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.county = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    context 'postcode' do
      it 'has min' do
        address.postcode = 'B7'
        expect(address).to_not be_valid
      end
      it 'has max' do
        address.postcode = 'B' * 9
        expect(address).to_not be_valid
      end
    end
  end

  context 'associations' do
    it('is addressable') { expect(address).to respond_to :addressable }
  end

  context 'methods' do
    context'#empty?' do
      let(:address) { Address.new }
      it 'empty' do
        expect(address).to be_empty
      end

      it 'with noted attribute not empty' do
        address.town = 'Bath'
        expect(address).to_not be_empty
      end

      it('with ignored attribute empty') do
        address.id = 8
        expect(address).to be_empty
      end
    end

    it 'Limits attributes copied' do
      client = client_new
      new_address = Address.new
      new_address.attributes = client.address.copy_approved_attributes
      expect(new_address.addressable_id).to be_nil
      expect(new_address.road).not_to be_nil
    end
  end
end
