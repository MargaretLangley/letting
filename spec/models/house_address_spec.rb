require 'spec_helper'

describe HouseAddress do

let(:address) { HouseAddress.new address_attributes addressable_id: 1, type: 'HouseAddress'}

  it ('valid') { expect(address).to be_valid }

  context 'validations presence' do
    it('#road_no') { address.road_no =nil; expect(address).not_to be_valid }
  end

end