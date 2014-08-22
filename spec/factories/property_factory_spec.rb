require 'rails_helper'

describe 'Property Factory' do

  describe 'default' do
    it 'creates with human_ref' do
      expect(property_new.human_ref).to eq 2002
    end
  end

  describe 'override' do
    it 'id changeable' do
      property = property_new id: 2
      expect(property.id).to eq 2
    end

    it 'human_ref changeable' do
      property = property_new human_ref: 3001
      expect(property.human_ref).to eq 3001
    end

    it 'address attributes' do
      property = property_new human_ref: 3001,
                              address_attributes: { road: 'Headingly Road' }
      expect(property.address.road).to eq 'Headingly Road'
    end
  end

  context 'with_charge' do
    describe 'default' do
      it 'has charge' do
        property = property_with_charge_create(charge: charge_create)
        expect(property.account.charges.first.charge_type).to eq 'Ground Rent'
      end

      it 'has charged_in' do
        property_with_charge_create(charge: charge_create)
        expect(ChargedIn.first.name).to eq 'Advance'
      end

      it 'has charge cycle' do
        property_with_charge_create(charge: charge_create)
        expect(ChargeCycle.first.name).to eq 'Mar/Sep'
      end

      it 'makes due_on' do
        property_with_charge_create(charge: charge_create)
        expect(DueOn.count).to eq 1
        expect(DueOn.first).to eq DueOn.new(day: 25, month: 3)
      end
    end

    it 'new is valid' do
      charge_create
      expect(property_with_charge_new).to be_valid
    end

    it 'create' do
      expect do
        property_with_charge_create(charge: charge_create)
      end.to_not raise_error
    end

    context 'and unpaid debit' do
      it 'generated (property created & debited new)' do
        charge_create
        property = property_with_charge_and_unpaid_debit
        property.account.prepare_for_form
        expect(property.account.debits.size).to eq(1)
      end
    end
  end
end
