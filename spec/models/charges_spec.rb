require 'spec_helper'

describe Charges do

  let(:charges) { Account.new.charges }

  context 'methods' do

    context 'generate chargeables' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after  { Timecop.return }

      it '#chargeables_between' do
        charges = account_and_charge_new.charges
        charges[0].id = 1 # avoid saving object to get id
        expect(charges.chargeables_between chargeable_date).to \
        eq [ChargeableInfo.from_charge(charge_id: 1,
                                       on_date: Date.new(2013, 3, 25),
                                       amount: 88.08,
                                       account_id: 1)]
      end
      def chargeable_date
        Date.new(2013, 3, 24)..Date.new(2013, 3, 25)
      end
    end

    it '#prepare' do
      expect(charges).to have(0).items
      charges.prepare
      expect(charges).to have(4).items
    end

    it '#cleans up form' do
      charges.build charge_attributes
      charges.prepare
      charges.clear_up_form
      expect(charges.reject(&:empty?)).to have(1).items
    end
  end
end
