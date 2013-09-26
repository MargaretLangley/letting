require 'spec_helper'

describe DebtGenerator do

  it 'returns' do
    DebtGenerator.create debt_generator_attributes
    expect(DebtGenerator.latest_debt_generated(10).length).to eq 1
    expect(DebtGenerator.latest_debt_generated(10).first).to eq \
        DebtGenerator.new id: 1, \
                          search_string: 'Lords', \
                          start_date: '2013-03-01', \
                          end_date: '2013-04-01'
  end

end
