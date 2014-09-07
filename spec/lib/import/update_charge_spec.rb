require 'rails_helper'
require_relative '../../../lib/import/update_charge'
# rubocop: disable Style/Documentation

module DB
  describe UpdateCharge, :import do
    before { Timecop.travel(Date.new(2013, 11, 01)) }
    after  { Timecop.return }

    describe 'updating charge start and end dates' do
      it 'nothing changes if charge has no debits' do
        charge = charge_new(start_date: MIN_DATE, end_date: MAX_DATE)
        (account = account_new charge: charge).save!
        UpdateCharge.do
        expect(account.charges.first.start_date).to eq Date.new 2000, 1, 1
        expect(account.charges.first.end_date).to eq Date.new 2100, 1, 1
      end

      it 'updates start date when charge debited' do
        charge = charge_new(start_date: MIN_DATE, end_date: MAX_DATE)
        (account = account_new charge: charge).save!
        account.debits << debit_new(on_date: '2013-3-25', charge_id: charge.id)
        account.debits << debit_new(on_date: '2012-3-25', charge_id: charge.id)
        account.save!
        UpdateCharge.do
        expect(Charge.first.start_date).to eq Date.new 2012, 3, 25
        expect(Charge.first.end_date).to eq Date.new 2100, 1, 1
      end

      it 'updates start and end of charge when charge has finished' do
        charge = charge_new(start_date: MIN_DATE, end_date: MAX_DATE)
        (account = account_new charge: charge).save!
        account.debits << debit_new(on_date: '2012-3-25', charge_id: charge.id)
        account.debits << debit_new(on_date: '2011-3-25', charge_id: charge.id)
        account.save!
        UpdateCharge.do
        expect(Charge.first.start_date).to eq Date.new 2011, 3, 25
        expect(Charge.first.end_date).to eq Date.new 2012, 3, 25
      end
    end
  end
end
