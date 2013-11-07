require 'spec_helper'

require_relative '../../../lib/import/update_charge'
module DB

  describe UpdateCharge do
    before { Timecop.travel(Date.new(2013, 11, 01)) }
    after  { Timecop.return }

    it 'finds oldest debit' do
      args = { charge_attributes: { start_date: MIN_DATE ,
                                    end_date: MAX_DATE } }
      account = account_and_charge_new args
      account.debits.build debit_attributes id: nil, on_date: '2013-3-25'
      account.debits.build debit_attributes id: nil, on_date: '2012-3-25'
      account.save!
      UpdateCharge.do
      expect(account.charges.first.start_date).to eq Date.new 2012,3,25
      expect(account.charges.first.end_date).to eq Date.new 2100,1,1
    end

    it 'finds oldest debit' do
      args = { charge_attributes: { start_date: MIN_DATE ,
                                    end_date: MAX_DATE } }
      account = account_and_charge_new args
      account.debits.build debit_attributes id: nil, on_date: '2012-3-25'
      account.debits.build debit_attributes id: nil, on_date: '2011-3-25'
      account.save!
      UpdateCharge.do
      expect(account.charges.first.start_date).to eq Date.new 2011,3,25
      expect(account.charges.first.end_date).to eq Date.new 2012,3,25

    end
  end
end
