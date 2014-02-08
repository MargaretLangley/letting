require 'spec_helper'

describe 'Agent Factory' do
  let(:agent) { agent_new }
  it('is valid') { expect(agent).to be_valid }
end
