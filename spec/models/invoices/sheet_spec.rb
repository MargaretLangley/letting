require 'rails_helper'

describe Sheet, type: :model do

  describe 'validations' do
    it('is valid') do
      expect(sheet_new).to be_valid
    end

    it 'requires a description' do
      expect(sheet_new invoice_name: '').to_not be_valid
    end

    it 'requires a phone' do
      expect(sheet_new phone: '').to_not be_valid
    end

    it 'requires vat' do
      expect(sheet_new vat: '').to_not be_valid
    end
  end
end
