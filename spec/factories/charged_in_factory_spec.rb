require 'rails_helper'

describe 'ChargedIn Factory' do

  let(:charged_in) { charged_in_create name: 'Advance' }
  it('is valid') { expect(charged_in).to be_valid }

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charged_in_create }
          .to change(ChargedIn, :count).by(1)
      end

      it 'has default id' do
        expect(charged_in_create.id).to eq(2)
      end

      it 'has default name' do
        expect(charged_in_create.name).to eq 'Advance'
      end
    end
  end
end
