require 'spec_helper'

describe 'debit_generator' do

  before(:each) do
    log_in
     visit '/debit_generators/'
  end

  it 'basic' do
    expect(current_path).to eq '/debit_generators/'

    expect(page).to have_text 'Invoice Range'
  end

end
