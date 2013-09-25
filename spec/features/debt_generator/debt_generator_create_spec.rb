require 'spec_helper'

describe 'debt_generator' do
  it 'creates debts' do
    property_factory_with_charge
    visit '/debt_generators'


  end
end