require 'rails_helper'

describe ChargeCycleDecorator do
  it 'returns cycle charges' do
    charge_cycle_create id: 4, name: 'Mar/Sep', order: 5
    expect(ChargeCycleDecorator.all).to eq [['Mar/Sep', 4]]
  end

  it 'orders them' do
    charge_cycle_create id: 1, name: 'Mar', order: 2
    charge_cycle_create id: 2, name: 'Sep', order: 1
    expect(ChargeCycleDecorator.all).to eq [['Sep', 2], ['Mar', 1]]
  end
end
