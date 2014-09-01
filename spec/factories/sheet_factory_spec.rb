require 'rails_helper'

describe 'Sheet Factory' do
  describe 'sheet_create' do
    describe 'default' do
      it 'is valid' do
        sheet_create id: 1,
                     description: 'Page 1 Invoice',
                     invoice_name: 'Morgan',
                     phone: '01710008',
                     vat: '89',
                     heading2: 'give you notice pursuant'
        expect(Sheet.count).to eq 1
      end
    end
  end
end
