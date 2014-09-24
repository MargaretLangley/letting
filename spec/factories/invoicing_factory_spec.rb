require 'rails_helper'

describe 'Invoicing Factory' do
  describe 'default' do
    it('is valid') { expect(invoicing_new).to be_valid }
    describe 'presence' do
      it 'property_range' do
        expect(invoicing_new property_range: nil).to_not be_valid
      end
      it('start_date') { expect(invoicing_new start_date: nil).to_not be_valid }
      it('end_date') { expect(invoicing_new end_date: nil).to_not be_valid }
      it('invoices') { expect(invoicing_new invoices: nil).to_not be_valid }
    end
  end
end
