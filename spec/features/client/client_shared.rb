def fill_in_form
  fill_in_client
  fill_in_client_address
  fill_in_client_entity
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
  expect_client
  expect_new_address
  expect_new_entity
end


private
  def fill_in_client
    fill_in 'client_human_client_id', with: '278'
  end

  def fill_in_client_address
     within_fieldset 'client_address' do
      select 'Flat', from: 'Type'
      fill_in 'Flat no', with: '471'
      fill_in 'House name', with: 'Trent Bridge'
      fill_in 'Road no', with: '63c'
      fill_in 'Road', with: 'Radcliffe Road'
      fill_in 'District', with: 'West Bridgford'
      fill_in 'Town', with: 'Nottingham'
      fill_in 'County', with: 'Notts'
      fill_in 'Postcode', with: 'NG2 6AG'
    end
  end

  def fill_in_client_entity
    within_fieldset 'client_entity_0' do
      fill_in 'Title', with: 'Mr'
      fill_in 'Initials', with: 'D C S'
      fill_in 'Name', with: 'Compton'
    end
  end


  def expect_client
    expect(page).to have_text '278'
  end

  def expect_new_address
    expect(page).to have_text '471'
    expect(page).to have_text 'Trent Bridge'
    expect(page).to have_text '63c'
    expect(page).to have_text 'Radcliffe Road'
    expect(page).to have_text 'West Bridgford'
    expect(page).to have_text 'Nottingham'
    expect(page).to have_text 'Notts'
    expect(page).to have_text 'NG2 6AG'
  end

  def expect_new_entity
    expect(page).to have_text 'Mr'
    expect(page).to have_text 'D C S'
    expect(page).to have_text 'Compton'
  end

