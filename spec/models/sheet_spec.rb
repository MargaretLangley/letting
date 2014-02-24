require 'spec_helper'

describe Sheet do
  let(:sheet) { property_new }
  it('is valid') { expect(sheet).to be_valid }

end
