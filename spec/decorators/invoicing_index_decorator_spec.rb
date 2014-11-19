require 'rails_helper'

describe InvoicingIndexDecorator do
  it '#created_at' do
    Timecop.travel(Time.local(2008, 9, 1, 10, 5, 1))
    invoicing_dec = InvoicingIndexDecorator.new invoicing_create
    expect(invoicing_dec.created_at).to eq '01 Sep 2008 10:05'
    Timecop.return
  end

  it '#period_first - displays formatted date' do
    invoicing_dec = InvoicingIndexDecorator.new \
                      invoicing_new period_first: Date.new(2010, 3, 25)
    expect(invoicing_dec.period_first).to eq '25/Mar/10'
  end

  it '#period_last - displays formatted date' do
    invoicing_dec = InvoicingIndexDecorator.new \
                      invoicing_new period_last: Date.new(2010, 3, 25)
    expect(invoicing_dec.period_last).to eq '25/Mar/10'
  end
end
