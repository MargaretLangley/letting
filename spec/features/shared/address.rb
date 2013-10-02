
def fill_in_address_nottingham
  fill_in 'Flat no', with: '471'
  fill_in 'House name', with: 'Trent Bridge'
  fill_in 'Road no', with: '63c'
  fill_in 'Road', with: 'Radcliffe Road'
  fill_in 'Town', with: 'Nottingham'
  fill_in 'County', with: 'Notts'
  fill_in 'Postcode', with: 'NG2 6AG'
end

def expect_address_nottingham
  expect(page).to have_text '471'
  expect(page).to have_text 'Trent Bridge'
  expect(page).to have_text '63c'
  expect(page).to have_text 'Radcliffe Road'
  expect(page).to have_text 'Nottingham'
  expect(page).to have_text 'Notts'
  expect(page).to have_text 'NG2 6AG'
end

def expect_address_edgbaston
  expect_index_address_edgbaston
  expect(page).to have_text 'Edgbaston'      # district
  expect(page).to have_text 'West Midlands'  # county
  expect(page).to have_text 'B5 7QU'         # postcode
end

def expect_index_address_edgbaston
  expect(page).to have_text '47'             # Flat No
  expect(page).to have_text 'Hillbank House' # House Name
  expect(page).to have_text '294'            # House No
  expect(page).to have_text 'Edgbaston Road' # Road
  expect(page).to have_text 'Birmingham'     # Town
end

def expect_address_edgbaston_by_field
  expect(find_field('Flat no').value).to have_text '47'
  expect(find_field('House name').value).to have_text 'Hillbank House'
  expect(find_field('Road no').value).to have_text '294'
  expect(find_field('Road').value).to have_text 'Edgbaston Road'
  expect(find_field('Town').value).to have_text 'Birmingham'
  expect(find_field('County').value).to have_text 'West Midlands'
  expect(find_field('Postcode').value).to have_text 'B5 7QU'
end
