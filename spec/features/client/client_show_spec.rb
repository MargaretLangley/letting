require 'spec_helper'

describe Client do
  it '#show' do
    client = client_factory id: 1, human_client_id: 3008
    visit '/clients/'
    click_on '3008'
    expect(current_path).to eq '/clients/1'
    expect_client_address
    expect_client_entity
  end

  def expect_client_address
    expect(page).to have_text '3008'
    expect(page).to have_text '294'
    expect(page).to have_text 'Edgbaston Road'
    expect(page).to have_text 'Edgbaston'
    expect(page).to have_text 'Birmingham'
    expect(page).to have_text 'West Midlands'
    expect(page).to have_text 'B5 7QU'
  end

  def expect_client_entity
    expect(page).to have_text 'Mr'
    expect(page).to have_text 'W G'
    expect(page).to have_text 'Grace'
  end

end