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
      it('#town')    { address.town =nil; expect(address).not_to be_valid }
      it('#road')    { address.road =nil; expect(address).not_to be_valid }
      it('#road_no') { address.road_no =nil; expect(address).not_to be_valid }
    end
  end

  context 'methods #empty? new address' do
    let(:address) { Address.new }
    it('empty') { expect(address).to be_empty }
    it('with noted attribute not empty') { address.town = 'Bath'; expect(address).to_not be_empty }
    it('with ignored attribute empty') { address.id = 8; expect(address).to be_empty}
  end
end
