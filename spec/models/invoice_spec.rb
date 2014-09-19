require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'default' do
    it 'initializes invoice' do
      expect(invoice_new).to be_valid
    end
  end
end
