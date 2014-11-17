require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do
    it 'basic' do
      log_in admin_attributes
      invoice_create id: 1
      (1..7).each { |guide_id| guide_create id: guide_id }
      template_create id: 2

      visit '/invoices/1'
      expect(page.title).to eq 'Letting - Invoice View'
    end
  end
end
