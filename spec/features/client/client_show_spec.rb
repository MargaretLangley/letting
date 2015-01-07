require 'rails_helper'

describe 'Client#show', type: :feature do
  before(:each) { log_in }

  it 'completes basic' do
    client_create(id: 1, human_ref: 87)
      .properties << property_new(human_ref: 2008)
    visit '/clients/1'

    expect(page.title).to eq 'Letting - View Client'
    expect_client_ref ref: 87
    expect_property_ref ref: 2008
  end

  def expect_client_ref(ref:)
    expect(page).to have_text ref
  end

<<<<<<< HEAD
  def expect_property_ref(ref:)
    expect(page).to have_text ref
  end

  describe 'appropriate properties message' do
    it 'displays message when client has no properties' do
      client_create id: 1
      visit '/clients/1'

      expect(page).to have_content /The client has no properties./i
    end

    it 'displays no message when client has properties' do
      client_create(id: 1)
        .properties << property_new(human_ref: 6008, account: account_new)
      visit '/clients/1'

      expect(page).to have_text '6008'
      expect(page).to_not have_content /The client has no properties./i
    end
  end
end
