require 'rails_helper'

describe 'Address Factory' do
  describe 'default' do
    it('is valid') { expect(address_new).to be_valid }
    it('has road') { expect(address_new.road).to eq 'Edgbaston Road' }
    it('has town') { expect(address_new.town).to eq 'Birmingham' }
    it('has county') { expect(address_new.county).to eq 'West Midlands' }
  end

  describe 'overrides' do
    it('alters road') { expect(address_new(road: 'Lond').road).to eq 'Lond' }
    it('alters town') { expect(address_new(town: 'Bath').town).to eq 'Bath' }
    it('alters county') { expect(address_new(county: 'Kt').county).to eq 'Kt' }
  end
end
