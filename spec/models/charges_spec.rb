require 'spec_helper'

describe 'Charges' do
  before { Timecop.travel(Date.new(2013, 1, 31)) }
  after { Timecop.return }

  let(:charges) { account_new.charges }

  it '#prepare_for_form' do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(4).items
  end

  it '#cleans up form' do
    charges.build charge_attributes
    charges.prepare
    charges.clear_up_form
    expect(charges.reject(&:marked_for_destruction?)).to have(1).item
  end
end