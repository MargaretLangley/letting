def fill_in_entity_wg_grace
  fill_in 'Title',    with: 'Mr'
  fill_in 'Initials', with: 'W G'
  fill_in 'Name',     with: 'Grace'
end

def expect_entity_wg_grace
  expect(page).to have_text 'Mr'
  expect(page).to have_text 'W. G.'
  expect(page).to have_text 'Grace'
end

def expect_entity_wg_grace_by_field
  expect(find_field('Title').value).to have_text 'Mr'
  expect(find_field('Initials').value).to have_text 'W G'
  expect(find_field('Name').value).to have_text 'Grace'
end

def fill_in_entity_dc_compto
  fill_in 'Title',    with: 'Mr'
  fill_in 'Initials', with: 'D C S'
  fill_in 'Name',     with: 'Compton'
end

def expect_entity_dc_compton
  expect(page).to have_text 'Mr'
  expect(page).to have_text 'D. C. S.'
  expect(page).to have_text 'Compton'
end
