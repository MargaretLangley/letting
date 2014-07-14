require 'spec_helper'

describe ChargeableInfo, type: :model do

  let(:chargeable_info) do
    ChargeableInfo.from_charge chargeable_attributes
  end

  context 'attributes' do
    it 'charge_id' do
      expect(chargeable_info.charge_id).to eq 1
    end

    it 'account_id' do
      expect(chargeable_info.account_id).to eq 2
    end

    it 'date' do
      expect(chargeable_info.on_date).to eq Date.new(2013, 3, 25)
    end

    it 'amount' do
      expect(chargeable_info.amount).to eq 88.08
    end
  end

  context 'methods' do

    it 'self.from_charge generates chargeable_info' do
      expect((ChargeableInfo.from_charge chargeable_attributes).class)
        .to be ChargeableInfo
    end

    it '#==' do
      expect(chargeable_info)
        .to eq ChargeableInfo.from_charge chargeable_attributes
    end

    it '#to_hash' do
      expect(chargeable_info.to_hash)
        .to eq 'charge_id' => 1,
               'on_date' => Date.new(2013, 3, 25),
               'amount' => 88.08,
               'account_id' => 2
    end
  end
end
