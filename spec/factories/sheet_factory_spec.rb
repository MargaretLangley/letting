require 'spec_helper'

describe 'sheet_factory' do
  let(:sheet) { sheet_factory }
  it('is valid') { expect(sheet).to be_valid }
end