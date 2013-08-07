require 'spec_helper'

describe FlatAddress do

let(:address) { FlatAddress.new address_attributes addressable_id: 1}

  it ('valid') { expect(address).to be_valid }

  context 'validations missing is valid' do
    it('#road_no') { address.road_no =nil; expect(address).to be_valid }
  end

end