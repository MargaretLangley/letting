require 'rails_helper'

describe 'ChargeCycle Factory' do

  let(:cycle) { charge_cycle_create name: 'Mar/Sep' }
  it('is valid') { expect(cycle).to be_valid }

end
