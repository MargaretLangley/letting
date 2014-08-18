require 'rails_helper'

describe 'Property Factory' do

  it 'not saves' do
    property = property_new
    expect(property.id).to eq nil
  end

  it 'id changeable' do
    property = property_new id: 2
    expect(property.id).to eq 2
  end

  it 'creates with human_ref' do
    property = property_new
    expect(property.human_ref).to eq 2002
  end

  it 'human_ref changeable' do
    property = property_new human_ref: 3001
    expect(property.human_ref).to eq 3001
  end

  context 'nested attributes' do

    it 'has nested attributes' do
      property = property_new human_ref: 3001
      expect(property.address.road).to eq 'Edgbaston Road'
    end

    it 'changes nested attributes' do
      property = property_new human_ref: 3001,
                              address_attributes: { road: 'Headingly Road' }
      expect(property.address.road).to eq 'Headingly Road'
    end
  end

  context 'with_charge' do
    it 'new is valid' do
      charge_structure_create
      expect(property_with_charge_new).to be_valid
    end

    it 'create!' do
      charge_structure_create
      expect { property_with_charge_create }.to_not raise_error
    end

    context 'and unpaid debit' do
      it 'generated (property created & debited new)' do
        charge_structure_create
        property = property_with_charge_and_unpaid_debit
        property.account.prepare_for_form
        expect(property.account.debits.size).to eq(1)
      end
    end
  end
end
