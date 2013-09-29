require 'spec_helper'

describe Address do

  let(:address) do
    Address.new road_no: '1', road: 'my road', town: 'my town', county: 'my county'
  end

  it ('valid') { expect(address).to be_valid }

  context 'validations' do

    context 'flat_no' do
      it ('can be blank')  { address.flat_no = '';expect(address).to be_valid }
      it ('has max') { address.flat_no = 'a' * 11; expect(address).to_not be_valid }
    end

    context 'house_name' do
      it ('can be blank') { address.house_name = ''; expect(address).to be_valid }
      it ('has max') { address.house_name = 'a' * 65; expect(address).to_not be_valid }
    end

    context 'road no' do
      it ('can be blank ')  do
        address.road_no = ''
        expect(address).to be_valid
      end
      it ('has max') {address.road_no = 'a' * 11; expect(address).to_not be_valid }
    end

    context 'road' do
      it ('has to be present') { address.road = ''; expect(address).to_not be_valid }
      it ('road has a max') { address.road = 'a' * 65; expect(address).to_not be_valid }
    end

    context 'district' do
      it ('can be blank') { address.district = ''; expect(address).to be_valid }
      it ('has min') { address.district = 'aa'; expect(address).to_not be_valid }
      it ('has max') { address.district = 'a' * 65; expect(address).to_not be_valid }
    end

    context 'town' do
      it ('can be blank') { address.town = ''; expect(address).to be_valid }
      it ('has min') { address.town = 'aa'; expect(address).to_not be_valid }
      it ('has max') { address.town = 'a' * 65; expect(address).to_not be_valid }
    end

    context 'county' do
      it ('must be present')  { address.county =nil; expect(address).not_to be_valid }
      it ('has min') { address.county = 'aa'; expect(address).to_not be_valid }
      it ('has max') { address.county = 'a' * 65; expect(address).to_not be_valid }
    end

    context 'postcode' do
      it ('has min') { address.postcode = 'B7'; expect(address).to_not be_valid }
      it ('has max') { address.postcode = 'B' *9; expect(address).to_not be_valid }
    end
  end

  context 'associations' do
    it('is addressable') { expect(address).to respond_to :addressable }
  end

  context 'methods' do
    context'#empty?' do
      let(:address) { Address.new }
      it('empty') { expect(address).to be_empty }
      it('with noted attribute not empty') { address.town = 'Bath'; expect(address).to_not be_empty }
      it('with ignored attribute empty') { address.id = 8; expect(address).to be_empty}
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