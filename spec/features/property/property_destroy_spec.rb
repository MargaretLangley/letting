require 'spec_helper'

describe Property, :type => :feature do

  before(:each) { log_in }

  it '#destroys a property' do
    property_create! human_ref: 9000
    visit '/properties'
    expect(page).to have_text '9000'
    expect { click_on 'Delete' }.to change(Property, :count).by(-1)
    expect(page).to have_text '9000'
    expect(page).to have_text 'successfully deleted!'
    expect(current_path).to eq '/properties'
  end
end
