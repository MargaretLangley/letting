require 'spec_helper'

describe Property do

  it '#destroys a property' do
    property = property_factory human_property_id: 9000
    visit '/properties'
    expect(page).to have_text '9000'
    expect{ click_on 'Delete'}.to change(Property, :count).by -1
    expect(page).not_to have_text '9000'
    expect(page).to have_text 'Property successfully deleted!'
    expect(current_path).to eq '/properties'
  end
end