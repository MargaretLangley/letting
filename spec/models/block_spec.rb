require 'spec_helper'

describe Block do
  let(:block) { Block.new client_id: 1, name: 'Beechfield'}

  context 'validations' do
    it('is valid') { expect(block).to be_valid }
    context 'presence' do
      it('client_id') { block.client_id = nil; expect(block).to_not be_valid }
      it('name') { block.name = nil; expect(block).to_not be_valid }
    end
  end

  context 'association' do
    it 'has properties' do
      expect(block).to respond_to(:properties)
    end
  end

end
