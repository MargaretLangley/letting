require_relative '../shared/address'

def fill_in_form

  fill_in 'client_human_client_id', with: '278'

  within_fieldset 'client_address' do
    fill_in_address_nottingham
  end

  within_fieldset 'client_entity_0' do
    fill_in_entity_wg_grace
  end

end

def invalidate_page
  within_fieldset 'client_address' do
    fill_in 'Road', with: ''
  end
end

def navigate_to_client_page
    click_on '278'
end

def expect_client_page
  expect(page).to have_text '278'
  expect_address_nottingham
  expect_entity_wg_grace
end
