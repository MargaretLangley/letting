require 'spec_helper'

describe Agent do

  let(:agent) do
    agent = Agent.new authorized: true, property_id: 1
    agent.entities.new person_entity_attributes
    agent.build_address address_attributes
    agent
  end

  it('is valid') { expect(agent).to be_valid }

  context 'new profile' do
    let(:new_profile) { Agent.new }
    it('has nil address') { expect(new_profile.address).to be_nil }
    it('has no entities') { expect(new_profile.entities.size).to eq 0 }
  end

  context 'prepared for form' do

    context 'which is already being used to contact and remains unaffected' do
      before do
        agent.save!
      end

      let(:full_profile) do
        profile = Agent.find agent.id
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
          full_profile.clear_up_form
          entities = saveable_entities full_profile.entities
          expect(entities).to have(1).items
        end
      end

      context 'stop using profile' do
        before do
          full_profile.authorized = false
          full_profile.clear_up_form
        end
        it 'marks entities for distruction' do
          entities = saveable_entities full_profile.entities
          expect(entities).to have(0).items
        end

        it 'delete address' do
          expect(full_profile.address.marked_for_destruction?).to be_true
        end
      end
    end

    let(:prepare_blank_profile) do
      profile = Agent.new authorized: false, property_id: 1
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
          prepare_blank_profile.authorized = false
          prepare_blank_profile.clear_up_form
        end

        it 'is valid to have no entities if not using information' do
          expect(prepare_blank_profile.authorized).to be_false
          expect(prepare_blank_profile).to be_valid
        end

        it 'empty entities are to be destroyed' do
          entities = saveable_entities prepare_blank_profile.entities
          expect(entities).to have(0).items
        end
      end

      context 'and if using the profile will keep contact' do
        before do
          prepare_blank_profile.authorized = true
          prepare_blank_profile.entities.new person_entity_attributes
          prepare_blank_profile.build_address address_attributes
          prepare_blank_profile.clear_up_form
        end

        it 'non empty entity kept' do
          entities = saveable_entities prepare_blank_profile.entities
          expect(entities).to have(1).items
        end

        it 'address kept' do
          expect(prepare_blank_profile.address.marked_for_destruction?)
            .to be_false
        end
      end
    end
    def saveable_entities entities
      entities.reject(&:marked_for_destruction?)
    end
  end
end
