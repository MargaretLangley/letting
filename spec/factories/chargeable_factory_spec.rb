require 'spec_helper'

describe 'ChargeableFactory' do

  it 'creates a new Chareagble' do
    expect(chargeable_info_new.amount).to eq 88.08
  end

end
