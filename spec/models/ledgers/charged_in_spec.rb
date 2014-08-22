require 'rails_helper'

RSpec.describe ChargedIn, type: :model do
  it 'is valid' do
    expect(ChargedIn.new name: 'Advance').to be_valid
  end

  it 'requies a name' do
    expect(ChargedIn.new name: '').to_not be_valid
  end
end
