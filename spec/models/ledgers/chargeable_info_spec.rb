require 'spec_helper'

describe ChargeableInfo, :ledgers, type: :model do

  let(:chargeable_info) do
    ChargeableInfo.from_charge charge_id: 1,
                               account_id: 2,
                               on_date: Date.new(2013, 3, 25),
                               amount: 88.08
  end

  describe 'attributes' do
    it('charge_id') { expect(chargeable_info.charge_id).to eq 1 }
    it('account_id') { expect(chargeable_info.account_id).to eq 2 }
    it('date') { expect(chargeable_info.on_date).to eq Date.new(2013, 3, 25) }
    it('amount') { expect(chargeable_info.amount).to eq 88.08 }
  end

  describe 'methods' do
    it 'self.from_charge generates chargeable_info' do
      expect((ChargeableInfo.from_charge chargeable_attributes).class)
        .to be ChargeableInfo
    end

    describe '#to_hash' do
      it 'outputs a hash' do
        expect(chargeable_info.to_hash)
          .to eq charge_id: 1,
                 account_id: 2,
                 on_date: Date.new(2013, 3, 25),
                 amount: 88.08
      end

      it 'overrides an attribute' do
        chargeable_hash = chargeable_info.to_hash amount: 90.08
        expect(chargeable_hash[:amount]).to eq 90.08
      end
    end
  end
end
