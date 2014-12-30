require 'rails_helper'

describe 'Client Account Show', type: :feature do
  before(:each) { log_in }

  it '#show' do
    credit = credit_new on_date: '2014-3-1', charge: charge_create
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 2008,
                                  account: account_new(credits: [credit]))

    visit '/clients_accounts/1'
    expect_correct_title
    expect_client_entity
    expect_client_address
    expect_property
  end

  def expect_correct_title
    expect(page.title).to eq 'Letting - Client Accounts'
  end

  def expect_client_address
    expect(page).to have_text '87'
  end

  def expect_client_entity
    expect(page).to have_text 'Grace'
  end

  def expect_property
    expect(page).to have_text '2008'
  end

  describe 'appropiate properties message' do
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
