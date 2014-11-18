require 'rails_helper'

describe 'Template Factory' do
  describe 'new' do
    # We create the object and test it has expected value
    describe 'default' do
      it 'has description' do
        expect(template_new.description).to eq 'Page 1 Invoice'
      end
      describe 'makes' do
        it 'has address' do
          expect(template_new.address).to_not be_nil
        end
      end
    end
    describe 'adds' do
      # adds guides..
    end
    describe 'overrides' do
      it 'changes description' do
        expect(template_new(description: 'new').description).to eq 'new'
      end

      it 'changes heading1' do
        expect(template_new(heading1: 'new').heading1).to eq 'new'
      end

      it 'changes address' do
        expect(template_new(address: address_new(road: 'new')).address.road)
          .to eq 'new'
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is valid' do
        expect { template_create }.to change(Template, :count).by(1)
      end
      describe 'makes' do
        it 'builds address' do
          expect(template_create.address).to_not be_nil
        end
      end
    end
  end
end
