require 'spec_helper'

describe Charges do

  let(:charges) { property_factory.charges }

  it "prepare" do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(2).items
    expect(charges[0].due_ons).to have(2).items
  end

  it 'cleans up' do
    charge = charges.build charge_attributes
    charge.due_ons.build due_on_attributes_0
    charges.build
    charges.clean_up_form
    expect(charges.reject(&:empty?)).to have(1).items
  end

end