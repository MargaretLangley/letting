require 'spec_helper'

describe 'Charges', :type => :model do
  before { Timecop.travel(Date.new(2013, 1, 31)) }
  after { Timecop.return }

  let(:charges) { account_new.charges }

  it '#prepare_for_form' do
    expect(charges.size).to eq(0)
    charges.prepare
    expect(charges.size).to eq(4)
  end

  it '#cleans up form' do
    charges.build charge_attributes
    charges.prepare
    charges.clear_up_form
    expect(charges.reject(&:marked_for_destruction?).size).to eq(1)
  end
end