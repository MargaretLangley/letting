require 'spec_helper'

describe Charges do

  let(:charges) { property_factory.charges }

  it "prepare" do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(1).items
  end

end