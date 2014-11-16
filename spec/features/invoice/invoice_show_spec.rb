require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do
    it 'basic' do
      log_in admin_attributes
      invoice_create id: 1
      guide_create id: 1

      visit '/invoices/1'
      expect(page.title).to eq 'Letting - Invoice Print'
    end
  end
end
