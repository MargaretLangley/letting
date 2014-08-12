require 'spec_helper'

describe 'ChargeFactory' do

  let(:charge) { charge_new }
  it('is valid') do
    charge_structure_create
    expect(charge).to be_valid
  end
end
