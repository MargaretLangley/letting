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
    context 'presence' do
      it('#county')  { address.county =nil; expect(address).not_to be_valid }
      it('#road')    { address.road =nil; expect(address).not_to be_valid }
    end

    it('#road_no')    { address.road_no =nil; expect(address).to be_valid }
    it('#house_name') { address.house_name =nil; expect(address).to be_valid }

    it('#road_no & #house_name') do
      address.road_no =nil
      address.house_name =nil
      expect(address).to_not be_valid
    end

    it ('flat_no can be blank')       { address.flat_no = '';expect(address).to be_valid }
    it ('flat_no has maximum length') { address.flat_no = 'a' * 11; expect(address).to_not be_valid }

    it ('house_name can be blank')       { address.house_name = ''; expect(address).to be_valid }
    it ('house_name has maximum length') { address.house_name = 'a' * 65; expect(address).to_not be_valid }

    it ('road_no can be blank')  { address.road_no = ''; expect(address).to be_valid }
    it ('road_no has a maximum length') {address.road_no = 'a' * 11; expect(address).to_not be_valid }

    it ('road string has to be present') { address.road = ''; expect(address).to_not be_valid }
    it ('road has a maximum length') { address.road = 'a' * 65; expect(address).to_not be_valid }

    it ('district can be blank') { address.district = ''; expect(address).to be_valid }
    it ('district has a minimum length') { address.district = 'aa'; expect(address).to_not be_valid }
    it ('district has a maximum length') { address.district = 'a' * 65; expect(address).to_not be_valid }

    it ('town can be blank') { address.town = ''; expect(address).to be_valid }
    it ('town has a minimum length') { address.town = 'aa'; expect(address).to_not be_valid }
    it ('town has a maximum length') { address.town = 'a' * 65; expect(address).to_not be_valid }

    it ('county cannot be blank')      { address.county = ''; expect(address).to_not be_valid }
    it ('county has a minimum length') { address.county = 'aa'; expect(address).to_not be_valid }
    it ('county has a maximum length') { address.county = 'a' * 65; expect(address).to_not be_valid }

    it ('postcode has a valid form') { address.postcode = 'B75 6NR'; expect(address).to be_valid }
    it ('postcode has an invalid form') { address.postcode = 'B7'; expect(address).to_not be_valid }

  end

  context 'methods #empty? new address' do
    let(:address) { Address.new }
    it('empty') { expect(address).to be_empty }
    it('with noted attribute not empty') { address.town = 'Bath'; expect(address).to_not be_empty }
    it('with ignored attribute empty') { address.id = 8; expect(address).to be_empty}
  end

  it 'Limits attributes copied' do
    client = client_factory human_id: 5
    new_address = Address.new
    new_address.attributes = client.address.copy_approved_attributes
    expect(new_address.addressable_id).to be_nil
    expect(new_address.road).not_to be_nil
  end
end
