
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
  [
    '471',
    'Trent Bridge',
    '63c',
    'Radcliffe Road',
    'Nottingham',
    'Notts',
    'NG2 6AG'
  ].each do |line|
    expect(page).to have_text line
  end
end

def expect_address_edgbaston
  expect_index_address
  [
    'Edgbaston',      # district
    'West Midlands',  # county
    'B5 7QU'          # postcode
  ].each do |line|
    expect(page).to have_text line
  end
end

def expect_index_address
  [
    '47',             # Flat No
    'Hillbank House', # House Name
    '294',            # House No
    'Edgbaston Road', # Road
    'Birmingham'      # Town
  ].each do |line|
    expect(page).to have_text line
  end
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
