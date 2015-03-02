require 'rails_helper'

#
# Creating a charge can only happen with current property
# Tests create and use a property in all instances.
#
describe 'Charge#create', type: :feature do
  let(:account) { AccountPage.new }
  before(:each) do
      log_in
    client_create \
      human_ref: 90,
      properties: [property_new(id: 1, human_ref: 80, account: account_new)]
  end




end
