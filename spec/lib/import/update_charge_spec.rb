require 'spec_helper'

require_relative '../../../lib/import/update_charge'
module DB

  describe UpdateCharge do
    before { Timecop.travel(Date.new(2013, 11, 01)) }
    after  { Timecop.return }

     it 'leaves alone charges without debits' do
      args = { charge_attributes: { start_date: MIN_DATE ,
                                    end_date: MAX_DATE } }
      (account = account_and_charge_new args).save!
      UpdateCharge.do
      expect(account.charges.first.start_date).to eq Date.new 2000,1,1
      expect(account.charges.first.end_date).to eq Date.new 2100,1,1
    end

    it 'updates only the start of recurring charge' do
      args = { charge_attributes: { start_date: MIN_DATE ,
                                    end_date: MAX_DATE } }
      (account = account_and_charge_new args).save!
      account.debits.build debit_attributes id: nil, on_date: '2013-3-25', charge_id: account.charges.first.id
      account.debits.build debit_attributes id: nil, on_date: '2012-3-25', charge_id: account.charges.first.id
      account.save!
      UpdateCharge.do
      expect(account.charges.first.start_date).to eq Date.new 2012,3,25
      expect(account.charges.first.end_date).to eq Date.new 2100,1,1
    end

    it 'updates start and end of charge which has finished' do
      args = { charge_attributes: { start_date: MIN_DATE ,
                                    end_date: MAX_DATE } }
      (account = account_and_charge_new args).save!
      account.debits.build debit_attributes id: nil, on_date: '2012-3-25', charge_id: account.charges.first.id
      account.debits.build debit_attributes id: nil, on_date: '2011-3-25', charge_id: account.charges.first.id
      account.save!
      UpdateCharge.do
      expect(account.charges.first.start_date).to eq Date.new 2011,3,25
      expect(account.charges.first.end_date).to eq Date.new 2012,3,25
    end

  end
end
