require 'spec_helper'

describe Block do
  let(:block) { Block.new name: 'Beechfield'}
  it('is valid') { expect(block).to be_valid }

  context 'validations' do
    context 'presence' do
      it('name') { block.name = nil; expect(block).to_not be_valid }
    end
    it ('name has maximum length')  do
      block.name = 'a' * 65; expect(block).to_not be_valid
    end
  end
end
