require 'rails_helper'

describe 'ChargeableInfoFactory' do
  describe 'default' do
    it('has account_id') { expect(chargeable_info_new.account_id).to eq 2 }
    it('has charge_id') { expect(chargeable_info_new.charge_id).to eq 1 }
    it 'has on_date' do
      expect(chargeable_info_new.on_date).to eq Date.new(2013, 3, 25)
    end
    it 'has period' do
      expect(chargeable_info_new.period)
        .to eq Date.new(2013, 3, 25)..Date.new(2013, 6, 30)
    end
    it('has amount') { expect(chargeable_info_new.amount).to eq 88.08 }
  end
end
