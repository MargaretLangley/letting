require 'rails_helper'

describe Template, type: :model do

  describe 'validations' do
    it('returns valid') { expect(template_new).to be_valid }
    it('description') { expect(template_new description: '').to_not be_valid }
    it('needs name') { expect(template_new invoice_name: '').to_not be_valid }
    it('requires a phone') { expect(template_new phone: '').to_not be_valid }
    it('requires vat number') { expect(template_new vat: '').to_not be_valid }
    it('requires heading') { expect(template_new heading1: '').to_not be_valid }
  end
end
