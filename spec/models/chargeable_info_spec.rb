require 'spec_helper'

describe ChargeableInfo do

  let(:chargeable_info) do
    ChargeableInfo.from_charge charge_id: 1, \
    on_date: Date.new(2013,5,3), \
    amount: 100.5
  end

  it 'charge_id' do
    expect(chargeable_info.charge_id).to eq 1
  end

  it 'date' do
    expect(chargeable_info.on_date).to eq Date.new(2013,5,3)
  end

  it 'amount' do
    expect(chargeable_info.amount).to eq 100.5
  end

  it 'amount as decimal' do
    debt = ChargeableInfo.from_charge charge_id: 1, \
    on_date: Date.new(2013,5,3), \
    amount: 100.50
    expect(debt.amount).to eq 100.5
  end

  context 'methods' do

    it '#==' do
      chargeable_info = ChargeableInfo.from_charge charge_id: 1, \
      on_date: Date.new(2013,5,3), \
      amount: 100.5
      expect(chargeable_info).to eq chargeable_info
    end

    it '#to_hash' do
      expect(chargeable_info.to_hash).to eq \
         'charge_id' => 1, 'on_date' => Date.parse("Fri, 03 May 2013"), 'amount' => 100.5
    end
  end
end