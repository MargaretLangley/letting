require 'rails_helper'

describe CycleDecorator do
  it 'returns cycle charges' do
    cycle_create id: 4, name: 'Mar/Sep', order: 5
    expect(CycleDecorator.all).to eq [['Mar/Sep', 4]]
  end

  it 'orders them' do
    cycle_create id: 1, name: 'Mar', order: 2
    cycle_create id: 2, name: 'Sep', order: 1
    expect(CycleDecorator.all).to eq [['Sep', 2], ['Mar', 1]]
  end
end
