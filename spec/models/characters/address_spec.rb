require 'rails_helper'

describe Address, type: :model do
  describe 'validations' do
    it('valid')   { expect(address_new).to be_valid }
    describe 'flat_no' do
      it('allows blanks') { expect(address_new flat_no: '').to be_valid }
      it('has max') { expect(address_new flat_no: 'a' * 11).to_not be_valid }
    end

    describe 'house_name' do
      it('allows blanks') { expect(address_new house_name: '').to be_valid }
      it('has max') { expect(address_new house_name: 'a' * 65).to_not be_valid }
    end

    describe 'road no' do
      it('allows blanks') { expect(address_new road_no: '').to be_valid }
      it('has max') { expect(address_new road_no: 'a' * 11).to_not be_valid }
    end

    describe 'road' do
      it('is required') { expect(address_new road: '').to_not be_valid }
      it('has max') { expect(address_new road: 'a' * 65).to_not be_valid }
    end

    describe 'district' do
      it('allows blanks') { expect(address_new district: '').to be_valid }
      it('has max') { expect(address_new district: 'a' * 65).to_not be_valid }
      it('has min') { expect(address_new district: 'a').to_not be_valid }
    end

    describe 'town' do
      it('allows blanks') { expect(address_new town: '').to be_valid }
      it('has min') { expect(address_new town: 'a').to_not be_valid }
      it('has max') { expect(address_new town: 'a' * 65).to_not be_valid }
    end

    describe 'county' do
      it('is required') { expect(address_new county: '').to_not be_valid }
      it('has min') { expect(address_new county: 'a').to_not be_valid }
      it('has max') { expect(address_new county: 'a' * 65).to_not be_valid }
    end

    describe 'postcode' do
      it('allows blanks') { expect(address_new postcode: '').to be_valid }
      it('has min') { expect(address_new postcode: 'B7').to_not be_valid }
      it('has max') { expect(address_new postcode: 'B' * 21).to_not be_valid }
    end

    describe 'nation' do
      it('allows blanks') { expect(address_new nation: '').to be_valid }
      it('has min') { expect(address_new nation: 'a').to_not be_valid }
      it('has max') { expect(address_new nation: 'a' * 65).to_not be_valid }
    end
  end

  describe 'methods' do
    describe '#address_lines' do
      it 'writes flat property' do
        address = Address.new address_attributes
        expect(address.address_lines).to contain_exactly \
          'Flat 47 Hillbank House',
          '294 Edgbaston Road',
          'Edgbaston',
          'Birmingham',
          'West Midlands',
          'B5 7QU'
      end

      it 'writes house from road' do
        expect(Address.new(road: 'Highroad').address_lines[0]).to eq 'Highroad'
      end
    end

    describe 'abbreviated_address' do
      it 'adds flat when present' do
        address = Address.new flat_no: '47', house_name: 'Hill', town: 'Brum'
        expect(address.abbreviated_address).to eq ['Flat 47 Hill', 'Brum']
      end
      it 'adds road when flat missing' do
        house = Address.new flat_no: '', road: 'Edge Road', town: 'Brum'
        expect(house.abbreviated_address).to eq ['Edge Road', 'Brum']
      end
      it 'adds town when present' do
        house = Address.new road: 'Edge', town: 'Brum', county: 'West'
        expect(house.abbreviated_address).to eq %w(Edge Brum)
      end
      it 'adds county when town missing' do
        house = Address.new road: 'Edge', town: '', county: 'West'
        expect(house.abbreviated_address).to eq %w(Edge West)
      end
    end

    context '#empty?' do
      it('starts empty') { expect(Address.new).to be_empty }

      it 'regards setting noted attributes as filling the object.' do
        expect(address_new town: 'Bath').to_not be_empty
      end

      it 'regards setting ignored attributes as the object remaining empty' do
        expect(Address.new id: 8).to be_empty
      end
    end

    it 'Limits attributes copied' do
      replica_address = Address.new
      replica_address.attributes = client_new.address.copy_approved_attributes
      expect(replica_address.addressable_id).to be_nil
      expect(replica_address.road).to be_present
    end
  end
end
