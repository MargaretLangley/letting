require 'rails_helper'

describe 'Client Account Show', type: :feature do
  before(:each) { log_in }

  it '#show' do
    charge =
      charge_create cycle: cycle_new(due_ons: [DueOn.new(day: 25, month: 3),
                                               DueOn.new(day: 30, month: 9)])
    payment = payment_new booked_on: '2014-3-1', amount: 17
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 63,
                                  account: account_new(charges: [charge],
                                                       payment: payment))

    visit '/clients_accounts/1'
    expect_title
    expect_client_ref
    expect_property
  end

  def expect_title
    expect(page.title).to eq 'Letting - Client Accounts'
  end

  def expect_client_ref
    expect(page).to have_text '87'
  end

  def expect_property
    expect(page).to have_text '63'
  end

  describe 'appropriate properties message' do
    it 'displays message when client has no properties' do
      client_create id: 1
      visit '/clients_accounts/1'

      expect(page.text).to match(/The client has no properties./i)
    end

    it 'does not list properties above 5999' do
      skip 'Not Yet Implemented'
      credit = credit_new on_date: '2014-3-1', charge: charge_create
      client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
        .properties << property_new(human_ref: 6008,
                                    account: account_new(credits: [credit]))
      visit '/clients_accounts/1'

      expect(page).to_not have_text '6008'
      expect(page.text).to_not match(/The client has no properties./i)
    end
  end

  describe 'search range' do
    it 'searches within date range' do
      skip 'Not Yet Implemented'
    end

    it 'searches within correct half-year range' do
      skip 'Not Yet Implemented'
    end
  end

  it 'totals items' do
    skip 'Not Yet Implemented'
  end
end
