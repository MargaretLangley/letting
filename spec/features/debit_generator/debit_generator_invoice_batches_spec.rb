require 'spec_helper'

describe 'debit_generator', type: :feature do

  before(:each) do
    log_in
    visit '/debit_generators/'
  end

  it 'has no Invoice Range setup' do
    expect(current_path).to eq '/debit_generators/'
    expect(page).to have_text 'Invoice Range'
    expect(page).to have_text 'NO Invoice Range available'
  end

end
