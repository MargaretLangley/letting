require 'spec_helper'

describe Charges do

  let(:charges) { Account.new.charges }

  it '#prepare' do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(4).items
  end

  it '#cleans up form' do
    charge = charges.build charge_attributes
    charges.prepare
    charges.clean_up_form
    expect(charges.reject(&:empty?)).to have(1).items
  end

  context 'generate debts for' do
    before { Timecop.freeze(Time.zone.parse('3/2/2013 12:00')) }
    after { Timecop.return }

    it '#charges_between' do
      charges = account_and_charge_new.charges
      charges[0].id = 1 # avoid saving object to get id
      expect(charges.charges_between Date.new(2013,3,24)..Date.new(2013,3,25)).to \
      eq [ DebtInfo.from_charge(charge_id: 1, \
                                on_date: Date.new(2013,3,25), \
                                amount: BigDecimal.new(88.08,8)) \
         ]
    end
  end
end