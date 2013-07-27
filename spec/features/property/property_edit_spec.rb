require 'spec_helper'

describe Property do

  it 'edits a property' do
    property = Property.create id: 1, human_property_reference: 8000
    property.create_location_address address_attributes

    visit '/properties/'
    click_on 'Edit'
    expect(current_path).to eq '/properties/1/edit'
    expect(find_field('property_human_property_reference').value).to have_text '8000'
    expect(find_field('Flat no').value).to have_text '47'
    expect(find_field('House name').value).to have_text 'Sunny Views'
    expect(find_field('Road no').value).to have_text '10a'
    expect(find_field('Road').value).to have_text 'High Street'
    expect(find_field('District').value).to have_text 'Kingswindford'
    expect(find_field('Town').value).to have_text 'Dudley'
    expect(find_field('County').value).to have_text 'West Midlands'
    expect(find_field('Postcode').value).to have_text 'DY6 7RA'
    fill_in 'property_human_property_reference', with: '8001'
    fill_in 'Flat no', with: '58'
    fill_in 'House name', with: 'River Brook'
    fill_in 'Road', with: 'Surrey Road'
    fill_in 'District', with: 'Merton'
    fill_in 'Town', with: 'London'
    fill_in 'County', with: 'Greater'
    fill_in 'Postcode', with: 'SW1 4HA'
    click_on 'Update Property'
    expect(current_path).to eq properties_path
    expect(page).to_not have_text '8000'
    expect(page).to have_text '8001'
    expect(page).to have_text('Property successfully updated!')
    expect(page).to have_text '10a'

    visit '/properties/1'
    expect(page).to have_text '58'
    expect(page).to have_text 'River Brook'
    expect(page).to have_text 'Merton'
    expect(page).to have_text 'Surrey Road'
    expect(page).to have_text 'London'
    expect(page).to have_text 'Greater'
    expect(page).to have_text 'SW1 4HA'
  end

end