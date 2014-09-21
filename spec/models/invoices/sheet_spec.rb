require 'rails_helper'

describe Sheet, type: :model do

  describe 'validations' do
    it('returns valid') { expect(sheet_new).to be_valid }
    it('Description') { expect(sheet_new description: '').to_not be_valid }
    it('requires a name') { expect(sheet_new invoice_name: '').to_not be_valid }
    it('requires a phone') { expect(sheet_new phone: '').to_not be_valid }
    it('requires a vat number') { expect(sheet_new vat: '').to_not be_valid }
    it('requires a heading') { expect(sheet_new heading1: '').to_not be_valid }
  end
end
