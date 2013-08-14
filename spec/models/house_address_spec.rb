require 'spec_helper'

describe HouseAddress do

let(:address) { HouseAddress.new address_attributes addressable_id: 1, type: 'HouseAddress'}

  it ('valid') { expect(address).to be_valid }

  context 'validations presence' do
    it('#road_no')    { address.road_no =nil; expect(address).to be_valid }
    it('#house_name') { address.house_name =nil; expect(address).to be_valid }

    it('#road_no & #house_name') do
      address.road_no =nil
      address.house_name =nil
      expect(address).to_not be_valid
    end

  end

end