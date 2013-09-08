require 'spec_helper'

describe DueOnsDecorator do
  let(:due_ons_dec) do
    charge = Charge.new
    charge.prepare
    due_ons_dec = DueOnsDecorator.new charge.due_ons
    due_ons_dec
  end


  it '#by_date' do
    expect(due_ons_dec.by_date.size).to eq 4
  end

  it '#every_month' do
    expect(due_ons_dec.every_month.size).to eq 1
  end
end