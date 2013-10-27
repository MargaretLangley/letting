require 'spec_helper'

describe 'Property Factory' do

  it 'not saves' do
    property = property_new
    expect(property.id).to eq nil
  end

  it 'id changeable' do
    property = property_new id: 2
    expect(property.id).to eq 2
  end

  it 'creates with human_id' do
    property = property_new
    expect(property.human_id).to eq 2002
  end

  it 'human_id changeable' do
    property = property_new human_id: 3001
    expect(property.human_id).to eq 3001
  end

  context 'nested attributes' do

    it 'has nested attributes' do
      property = property_new human_id: 3001
      expect(property.address.road).to eq 'Edgbaston Road'
    end

    it 'changes nested attributes' do
      property = property_new human_id: 3001,
                              address_attributes: { road: 'Headingly Road' }
      expect(property.address.road).to eq 'Headingly Road'
    end
  end

  context 'with charge and unpaid debit' do
    it 'has both' do
      property = property_with_charge_and_unpaid_debit
      property.account.prepare_for_form
      expect(property.account.charges.reject(&:empty?)).to have(1).items
      expect(property.account.credits_for_unpaid_debits).to have(1).items
    end
  end

  context 'with unpaid debit' do
    it 'has debit' do
      property = property_with_unpaid_debit
      property.account.prepare_for_form
      expect(property.account.credits_for_unpaid_debits).to have(1).items
    end
  end

end
