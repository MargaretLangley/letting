require 'spec_helper'

describe BillingProfile do

  let(:billing_profile) do
    billing_profile = BillingProfile.new use_profile: true, property_id: 1
    billing_profile.entities.new person_entity_attributes
    billing_profile.build_address address_attributes
    billing_profile
  end

  it ('is valid') { expect(billing_profile).to be_valid }

  context 'new profile' do
    let(:new_profile) { BillingProfile.new }
    it ('has nil address') { expect(new_profile.address).to be_nil }
    it ('has no entities') { expect(new_profile.entities.size).to eq 0 }
  end

  context 'prepared for form' do

    context 'which is already being used to contact and remains unaffected' do
      before do
        billing_profile.save!
      end

      let(:full_profile) do
        profile = BillingProfile.find billing_profile.id
        profile.prepare_for_form
        profile
      end

      it 'check address' do
        expect(full_profile.address.road).to eq 'Edgbaston Road'
      end

      it 'check entities' do
        expect(full_profile.entities[0].name).to eq 'Grace'
        expect(full_profile.entities[1].name).to be_nil
      end

      context 'cleanup does not affect' do
        it 'valid entities are kept' do
          full_profile.clear_up_after_form
          expect(full_profile.entities.reject(&:marked_for_destruction?)).to have(1).items
        end
      end

      context 'stop using profile' do
        before do
          full_profile.use_profile = false
          full_profile.clear_up_after_form
        end
        it 'marks entities for distruction' do
          expect(full_profile.entities.reject(&:marked_for_destruction?)).to have(0).items
        end

        it 'delete address' do
          expect(full_profile.address.marked_for_destruction?).to be_true
        end
      end
    end

    let(:prepare_blank_profile) do
      profile = BillingProfile.new use_profile: false, property_id: 1
      profile.prepare_for_form
      profile
    end

    context 'which is blank' do
      it 'has a blank address' do
        expect(prepare_blank_profile.address).to be_empty
      end

      it 'has entities but all blank' do
        expect(prepare_blank_profile.entities).to have(2).items
        expect(prepare_blank_profile.entities).to be_all(&:empty?)
      end

      context 'and remains blank after cleanup' do
        before do
          prepare_blank_profile.use_profile = false
          prepare_blank_profile.clear_up_after_form
        end

        it 'is valid to have no entities if not using information' do
          expect(prepare_blank_profile.use_profile).to be_false
          expect(prepare_blank_profile).to be_valid
        end

        it 'empty entities are to be destroyed' do
          expect(prepare_blank_profile.entities.reject(&:marked_for_destruction?)).to have(0).items
        end
      end

      context 'and if using the profile will keep contact' do
        before do
          prepare_blank_profile.use_profile = true
          prepare_blank_profile.entities.new person_entity_attributes
          prepare_blank_profile.build_address address_attributes
          prepare_blank_profile.clear_up_after_form
        end

        it 'non empty entity kept' do
          expect(prepare_blank_profile.entities.reject(&:marked_for_destruction?)).to have(1).items
        end

        it 'address kept' do
          expect(prepare_blank_profile.address.marked_for_destruction?).to be_false
        end

      end

    end
  end

  context 'Attributes' do
  end

  context 'Associations' do

    context '#entities' do
      it('is entitieable') { expect(billing_profile).to respond_to(:entities) }
    end

    context '#address' do

      it('is addressable') { expect(billing_profile).to respond_to :address }

      it 'saving nil address does not change address count' do
        billing_profile.address = nil
        expect { billing_profile.save! }.to change(Address, :count).by 0
      end

      it 'is saved when filled in' do
        expect { billing_profile.save! }.to change(Address, :count).by 1
      end

    end

  end

end
