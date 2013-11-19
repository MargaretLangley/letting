require 'spec_helper'

describe 'ChargeFactory' do

  let(:charge) { charge_new }
  it('is valid') { expect(charge).to be_valid }

end
