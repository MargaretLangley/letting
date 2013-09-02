require_relative '../shared/address'
require_relative '../shared/entity'


def fill_in_form

  fill_in 'Client ID', with: '278'

  within_fieldset 'client_entity_0' do
    fill_in_entity_wg_grace
  end

  within_fieldset 'client_address' do
    fill_in_address_nottingham
  end

end

def invalidate_page
  within_fieldset 'client_address' do
    fill_in 'Road', with: ''
  end
end

def navigate_to_client_page human_id
    click_on human_id
end

def expect_client_page
  expect(page).to have_text '278'
  expect_address_nottingham
  expect_entity_wg_grace
end
