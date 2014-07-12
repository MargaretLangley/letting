require 'spec_helper'

describe Settlement do

  it 'resolve_credit' do
    debit1 = Debit.create! debit_attributes amount: 48.08, on_date: '25/3/2013'
    debit2 = Debit.create! debit_attributes amount: 20.00, on_date: '25/3/2014'
    credit = Credit.new credit_attributes amount: 88.08

    Settlement.resolve_credit credit, [debit1, debit2]

    expect(credit.settlements.size).to eq(2)
    expect(credit.settlements.first.amount).to eq 48.08
    expect(credit.settlements.last.amount).to eq 20.00
  end

  it 'resolve_debit' do
    credit1 = Credit.create! credit_attributes amount: 44.04
    credit2 = Credit.create! credit_attributes amount: 40.04
    debit = Debit.new debit_attributes amount: 88.08

    Settlement.resolve_debit debit, [credit1, credit2]

    expect(debit.settlements.size).to eq(2)
    expect(debit.settlements.first.amount).to eq 44.04
    expect(debit.settlements.last.amount).to eq 40.04
  end
end
