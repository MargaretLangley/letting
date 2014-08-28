require 'rails_helper'

describe PropertyDecorator do

  let(:property) { PropertyDecorator.new property_new }

  let(:house) do
    property.address.flat_no = ''
    property.address.house_name = ''
    property
  end

  describe '#client_ref' do
    it 'nil when client unknown' do
      property.client = nil
      expect(property.client_ref).to eq nil
    end

    it 'client_ref when known' do
      property.client = client_new human_ref: 8008
      expect(property.client_ref).to eq 8008
    end
  end

  it 'writes flat name' do
    expect(property.occupier).to eq 'Mr W. G. Grace'
  end

  it 'writes flat property' do
    expect(property.address_lines[0]).to eq 'Flat 47 Hillbank House'
  end

  it 'generates abbrivated address' do
    expect(property.abbreviated_address).to eq 'Flat 47 Hillbank House'
  end

  describe 'Agent' do
    context 'authorized for property' do
      it 'name returned' do
        agent = agent_new entities: [Entity.new(name: 'Willis')]
        property = PropertyDecorator.new property_create agent: agent
        expect(property.agent_name).to eq 'Willis'
      end

      it 'address returned' do
        agent = agent_new address: address_new(road: 'Wiggiton')
        property = PropertyDecorator.new property_create agent: agent
        expect(property.agent_address_lines[0]).to eq 'Wiggiton'
      end
    end

    context 'unauthored for property' do
      it 'name missing' do
        expect(property.agent_name).to eq 'None'
      end

      it 'address missing' do
        expect(property.agent_address_lines).to eq ['-']
      end
    end
  end
end
