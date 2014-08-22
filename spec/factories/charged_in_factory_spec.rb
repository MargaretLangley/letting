require 'rails_helper'

describe 'ChargedIn Factory' do

  describe 'valid requires' do
    it('needs a name') { expect(charged_in_new name: '').to_not be_valid }
  end

  describe 'new' do
    context 'default' do
      it('is valid') { expect(charged_in_new).to be_valid }
      it('has default name') { expect(charged_in_create.name).to eq 'Advance' }
      it('has default id') { expect(charged_in_new.id).to eq(2) }
    end
  end

  describe 'create' do
    it('is valid') { expect(charged_in_create).to be_valid }

    context 'default' do
      it 'is created' do
        expect { charged_in_create }.to change(ChargedIn, :count).by(1)
      end
    end
  end
end
