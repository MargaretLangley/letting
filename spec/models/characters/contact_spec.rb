require 'rails_helper'

shared_examples_for Contact do
  describe '#prepares_for_form' do
    it 'prepares address' do
      contactable = described_class.new
      expect(contactable.address).to be_nil
      contactable.prepare_for_form
      expect(contactable.address).to_not be_nil
    end

    it '#clear_up_form destroys address' do
      contactable = described_class.new
      contactable.prepare_for_form
      contactable.clear_up_form
      expect(contactable.address).to_not be_nil
    end
  end
end

describe Property do
  it_behaves_like Contact
end

describe Agent do
  it_behaves_like Contact
end

describe Client do
  it_behaves_like Contact
end
