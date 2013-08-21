require 'spec_helper'

describe Charges do

  class Property < ActiveRecord::Base
    include Charges
  end

  let(:charges) { Property.new.charges }

  it '#prepare' do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(2).items
    expect(charges[0].due_ons).to have(2).items
  end

  it '#cleans up form' do
    charge = charges.build charge_attributes
    charge.due_ons.build due_on_attributes_0
    charges.build
    charges.clean_up_form
    expect(charges.reject(&:empty?)).to have(1).items
  end

  context '#first_or_initialize' do
    before(:each) do
      charge = charges.build charge_attributes
      charge.due_ons.build due_on_attributes_0
    end

    it 'initializes if not found' do
      expect(charges.first_or_initialize 'first seen').to \
        be_empty
    end

    it 'return if found' do
      expect(charges.first_or_initialize 'Ground Rent').to_not \
        be_empty
    end
  end

end