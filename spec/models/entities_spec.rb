require 'spec_helper'

describe Entities do

  let(:entities) { base_property.entities }

  it 'creates #full_name' do
    expect(entities.full_name).to eq 'Mr W. G. Grace'
  end

  it 'creates #full_name' do
    entities.build title: 'Mr', name: 'Stuart'
    expect(entities.full_name).to eq 'Mr W. G. Grace & Mr Stuart'
  end

end
