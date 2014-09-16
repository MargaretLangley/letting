require 'rails_helper'

describe Payment, type: :feature do

  before(:each) { log_in }

  it 'shows record' do
    property_create account: account_new(payment: payment_create(id: 1),
                                         charge: charge_new,
                                         debit: debit_new)
    visit '/payments/1'
    expect(page.title).to eq 'Letting - View Payment'
  end
end
