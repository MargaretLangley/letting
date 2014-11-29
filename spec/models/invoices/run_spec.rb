require 'rails_helper'

RSpec.describe Run, type: :model do
  it('is valid') { expect(run_new).to be_valid }
  describe 'validates presence' do
    it '#invoice_date' do
      (run = run_new).invoice_date = nil
      expect(run).to_not be_valid
    end
    it '#invoices' do
      expect(run_new invoices: nil).to_not be_valid
    end
  end
end
